{ lib
, stdenv
, fetchurl
, automake
, autoconf
, libX11
}:

stdenv.mkDerivation rec {
  pname = "libstroke";
  version = "0.5.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20161204100704/http://etla.net/libstroke/${pname}-${version}.tar.gz";
    sha256 = "0bbpqzsqh9zrc6cg62f6vp1p4dzvv37blsd0gdlzdskgwvyzba8d";
  };

  nativeBuildInputs = [ automake autoconf ];
  buildInputs = [ libX11 ];

  # libstroke ships with an ancient config.sub that doesn't know about x86_64, so regenerate it.
  # Also, modern automake doesn't like things and returns error code 63.  But it generates the file.
  preConfigure = ''
      rm config.sub
      autoconf
      automake -a || true
    '';

  meta = {
    description = "Library for simple gesture recognition";
    homepage = "https://web.archive.org/web/20161204100704/http://etla.net/libstroke/";
    license = lib.licenses.gpl2;

    longDescription =
      '' libstroke, last updated in 2001, still successfully provides a basic
        gesture recognition engine based around a 3x3 grid.  It's simple and
        easy to work with, and notably used by FVWM.
      '';

    platforms = lib.platforms.linux;
  };
}
