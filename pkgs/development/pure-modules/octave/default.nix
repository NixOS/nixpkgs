{ stdenv, fetchurl, pkgconfig, pure, octave, gcc6 }:

stdenv.mkDerivation rec {
  baseName = "octave";
  version = "0.9";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "0l1mvmi3rpabzjcrk6p04rdn922mvdm9x67zby3dha5iiccc47q0";
  };

  buildInputs = [ pkgconfig gcc6 ];
  propagatedBuildInputs = [ pure octave ];
  makeFlags = "libdir=$(out)/lib prefix=$(out)/";
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "An Octave module for the Pure programming language";
    homepage = http://puredocs.bitbucket.org/pure-octave.html;
    license = stdenv.lib.licenses.gpl3Plus;
    # This is set to none for now because it does not work with the
    # current stable version of Octave.
    platforms = stdenv.lib.platforms.none;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
