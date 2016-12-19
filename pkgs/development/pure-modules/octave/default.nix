{ stdenv, fetchurl, pkgconfig, pure, octave }:

stdenv.mkDerivation rec {
  baseName = "octave";
  version = "0.7";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "04c1q5cjcyc5sg15ny1hn43rkphja3virw4k110cahc3piwbpsqk";
  };

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
