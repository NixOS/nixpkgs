{ stdenv
, lib
, fetchgit
, autoreconfHook
, optimize ? false # impure hardware optimizations
}:
stdenv.mkDerivation rec {
  pname = "gf2x";
  version = "1.3.0";

  # upstream has plans to move to gitlab:
  # https://github.com/NixOS/nixpkgs/pull/45299#issuecomment-564477936
  src = fetchgit {
    url = "https://scm.gforge.inria.fr/anonscm/git/gf2x/gf2x.git";
    rev = "gf2x-${version}";
    sha256 = "04g5jg0i4vz46b4w2dvbmahwzi3k6b8g515mfw7im1inc78s14id";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  # no actual checks present yet (as of 1.2), but can't hurt trying
  # for an indirect test, run ntl's test suite
  doCheck = true;

  configureFlags = lib.optionals (!optimize) [
    "--disable-hardware-specific-code"
  ];

  meta = with lib; {
    description = ''Routines for fast arithmetic in GF(2)[x]'';
    homepage = http://gf2x.gforge.inria.fr;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin timokau ];
    platforms = platforms.unix;
  };
}
