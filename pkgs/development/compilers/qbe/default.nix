{ lib, stdenv
, fetchgit
, unstableGitUpdater
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "unstable-2021-10-26";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "900805a8fe5cfa799966c4ef221524e967c44ca5";
    sha256 = "sha256-ahUpG2JH3Ee6FUGfTYZZ2TLk5tF6ovvMxbsjZjVug2o=";
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
