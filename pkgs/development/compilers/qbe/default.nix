{ lib, stdenv
, fetchgit
, unstableGitUpdater
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "unstable-2021-11-10";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "b0f16dad64d14f36ffe235b2e9cca96aa3ce35ba";
    sha256 = "sha256-oPgr8PDxGNqIWxWsvVr9B8oN0Io/pUuzgIkZfY/qD+o=";
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
