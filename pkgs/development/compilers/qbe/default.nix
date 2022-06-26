{ lib, stdenv
, fetchurl
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "qbe";
  version = "1.0";

  src = fetchurl {
    url = "https://c9x.me/compile/release/qbe-${version}.tar.xz";
    sha256 = "257ef3727c462795f8e599771f18272b772beb854aacab97e0fda70c13745e0c";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  passthru.tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix {};

  meta = with lib; {
    homepage = "https://c9x.me/compile/";
    description = "A small compiler backend written in C";
    maintainers = with maintainers; [ fgaz ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
