{ stdenv, fetchurl, pkgconfig, pure, octave }:

stdenv.mkDerivation rec {
  baseName = "octave";
  version = "0.9";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "001fc2188bb128d8865fff989e6adb5588645b26e09a9999fc4bdd3c62dd3550";
  };

  CPPFLAGS = "-std=c++11";

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure octave ];
  makeFlags = "libdir=$(out)/lib prefix=$(out)/";
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "An Octave module for the Pure programming language";
    homepage = http://puredocs.bitbucket.org/pure-octave.html;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
