{ stdenv, fetchurl, pkgconfig, python3, udev, systemd }:

let
  name = "media-player-info-23";
in

  stdenv.mkDerivation {
    inherit name;

    src = fetchurl {
      url = "https://www.freedesktop.org/software/media-player-info/${name}.tar.gz";
      sha256 = "1jy8xh4xjgjc4wj4qrw6sx2j3606zsj4bgiczhzf3xlpnkh6vax9";
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
      homepage = https://www.freedesktop.org/wiki/Software/media-player-info/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ ttuegel ];
      platforms = with platforms; linux;
    };
  }
