{stdenv, fetchurl, automake, autoconf, x11}:

stdenv.mkDerivation {
  name = "libstroke-0.5.1";

  src = fetchurl {
    url = http://etla.net/libstroke/libstroke-0.5.1.tar.gz;
    sha256 = "0da9f5fde66feaf6697ba069baced8fb3772c3ddc609f39861f92788f5c7772d";
  };

  buildInputs = [ automake autoconf x11 ];

  # libstroke ships with an ancient config.sub that doesn't know about x86_64, so regenerate it.
  # Also, modern automake doesn't like things and returns error code 63.  But it generates the file.
  preConfigure = ''
      rm config.sub
      autoconf
      automake -a || true
    '';

  meta = {
    description = "Libstroke, a library for simple gesture recognition";
    homepage = http://etla.net/libstroke/;
    license = stdenv.lib.licenses.gpl2;

    longDescription =
      '' libstroke, last updated in 2001, still successfully provides a basic
        gesture recognition engine based around a 3x3 grid.  It's simple and
        easy to work with, and notably used by FVWM.
      '';

    platforms = stdenv.lib.platforms.linux;
  };
}
