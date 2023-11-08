{ lib
, stdenv
, callPackage
, fetchgit
}:

stdenv.mkDerivation {
  pname = "qbe";
  version = "1.1-unstable-2023-08-18";

  src = fetchgit {
    url = "git://c9x.me/qbe.git";
    rev = "0d929287d77ccc3fb52ca8bd072678b5ae2c81c8";
    hash = "sha256-4pwkMUDnOI11P+priMowf9HE/Dva8FKQIrk0rEDa1NE=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  passthru = {
    tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix { };
  };

  meta = with lib; {
    homepage = "https://c9x.me/compile/";
    description = "A small compiler backend written in C";
    maintainers = with maintainers; [ fgaz onemoresuza ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
