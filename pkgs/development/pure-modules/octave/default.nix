{ stdenv, fetchurl, pkgconfig, pure, octave }:

stdenv.mkDerivation rec {
  baseName = "octave";
  version = "0.6";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "5a42e8dff8023f6bf1214ed31b7999645d88ce2f103d9fba23b527259da9a0df";
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

    # See https://bitbucket.org/purelang/pure-lang/issues/38
    broken = true;
  };
}
