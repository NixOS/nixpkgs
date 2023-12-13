{ lib, stdenv
, fetchzip
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "1.1";

  src = fetchzip {
    url = "https://c9x.me/compile/release/qbe-${version}.tar.xz";
    sha256 = "sha256-yFZ3cpp7eLjf7ythKFTY1YEJYyfeg2en4/D8+9oM1B4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  passthru = {
    tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix {};
  };

  meta = with lib; {
    homepage = "https://c9x.me/compile/";
    description = "A small compiler backend written in C";
    maintainers = with maintainers; [ fgaz ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
