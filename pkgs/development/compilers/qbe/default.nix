{ lib, stdenv
, fetchgit
, unstableGitUpdater
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "unstable-2022-03-11";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "c7842d84da65bcaf2d3c82aa69fb3ec930c7369f";
    sha256 = "sha256-fbxeoMJcVltrIGRLdJtxWykGIop8DVzpfrBatXniDPk=";
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
