{ stdenv, lib, fetchurl, python, zip, fop }:

stdenv.mkDerivation rec {
  name = "bgnet-${version}";
  version = "3.0.21";

  src = fetchurl {
    url = https://beej.us/guide/bgnet/bgnet.tgz;
    sha256 = "00ggr5prc5i3w9gaaw2sadfq6haq7lmh0vdilaxx8xz9z5znxvyv";
  };

  buildInputs = [ python zip fop ];

  preBuild = ''
    sed -i "s/#disable=1/disable=1/" bin/bgvalidate
    # build scripts need some love
    patchShebangs .
  '';

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';

  meta = {
    description = "Beej’s Guide to Network Programming";
    homepage = https://beej.us/guide/bgnet/;
    license = lib.licenses.unfree;

    maintainers = with lib.maintainers; [ profpatsch ];
  };
}
