{ lib, stdenv
, fetchgit
, unstableGitUpdater
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "unstable-2021-12-05";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "367c8215d99054892740ad74c690b106c45ebf60";
    sha256 = "sha256-xhTEiFR1RXMHtxmXlRof3O8monXEjstyWP3GClZmMuU=";
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
