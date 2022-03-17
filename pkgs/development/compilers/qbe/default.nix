{ lib, stdenv
, fetchgit
, unstableGitUpdater
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "unstable-2022-03-17";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "c6b41eb8c8cece8266b2173a83216e1ce77eb2be";
    sha256 = "sha256-vpNZNED+C9VMzWyyyntQuBgTvbpZpJ/EwOztdOEP7vI=";
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
