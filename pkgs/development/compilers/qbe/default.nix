{ lib, stdenv
, fetchgit
, unstableGitUpdater
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "unstable-2021-06-17";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "6d9ee1389572ae985f6a39bb99dbd10cdf42c123";
    sha256 = "NaURS5Eu8NBd92wGQcyFEXCALU9Z93nNQeZ8afq4KMw=";
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
