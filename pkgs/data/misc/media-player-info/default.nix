{ stdenv, fetchurl, pkgconfig, python3, udev, systemd }:

let
  name = "media-player-info-22";
in

  stdenv.mkDerivation {
    inherit name;

    src = fetchurl {
      url = "http://www.freedesktop.org/software/media-player-info/${name}.tar.gz";
      sha256 = "0di3gfx5z8c34yspzyllydr5snzg71r985kbqhrhb1il51qxgrvy";
    };

    buildInputs = [ udev systemd ];
    nativeBuildInputs = [ pkgconfig python3 ];

    postPatch = ''
      patchShebangs ./tools
    '';

    preConfigure = ''
      configureFlags="$configureFlags --with-udevdir=$out/lib/udev"
    '';

    meta = with stdenv.lib; {
      description = "A repository of data files describing media player capabilities";
      homepage = "http://www.freedesktop.org/wiki/Software/media-player-info/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ ttuegel ];
    };
  }
