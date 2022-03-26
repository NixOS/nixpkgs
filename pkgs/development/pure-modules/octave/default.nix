{ lib, stdenv, fetchurl, pkg-config, pure, octave }:

stdenv.mkDerivation rec {
  pname = "pure-octave";
  version = "0.9";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-octave-${version}.tar.gz";
    sha256 = "0l1mvmi3rpabzjcrk6p04rdn922mvdm9x67zby3dha5iiccc47q0";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure octave ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "An Octave module for the Pure programming language";
    homepage = "http://puredocs.bitbucket.org/pure-octave.html";
    license = lib.licenses.gpl3Plus;
    # This is set to none for now because it does not work with the
    # current stable version of Octave.
    platforms = lib.platforms.none;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
