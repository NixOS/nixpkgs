{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  _name   = "liblockfile";
  version = "1.09";
  name    = "${_name}-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/libl/${_name}/${_name}_${version}.orig.tar.gz";
    sha256 = "0zqvbxls1632wqfhv4v3q2djzlz9391h0wdgsvhnaqrr0nx9x5qn";
  };

  preConfigure = ''
    sed -i -e 's/install -g [^ ]* /install /' Makefile.in
  '';

  preInstall = ''
    mkdir -p $out/{bin,lib,include,man} $out/man/man{1,3}
  '';


  meta = {
    description = "Shared library with NFS-safe locking functions";
    homepage = http://packages.debian.org/unstable/libs/liblockfile1;
    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}
