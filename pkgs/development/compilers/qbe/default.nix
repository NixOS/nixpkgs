{ lib, stdenv
, fetchgit
, unstableGitUpdater
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "unstable-2021-10-28";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "0d68986b6f6aa046ab13776f39cc37b67b3477ba";
    sha256 = "sha256-K1XpVoJoY8QuUdP5rKnlAs4yTn5jhh9LKZjHalliNKs=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  passthru = {
    tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix {};
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    homepage = "https://c9x.me/compile/";
    description = "A small compiler backend written in C";
    maintainers = with maintainers; [ fgaz ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
