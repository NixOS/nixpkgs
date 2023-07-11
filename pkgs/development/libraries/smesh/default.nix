{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, ninja, opencascade
, Cocoa }:

stdenv.mkDerivation rec {
  pname = "smesh";
  version = "6.7.6";

  src = fetchFromGitHub {
    owner = "tpaviot";
    repo = "smesh";
    rev = version;
    sha256 = "1b07j3bw3lnxk8dk3x1kkl2mbsmfwi98si84054038lflaaijzi0";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-with-clang.patch";
      url = "https://github.com/tpaviot/smesh/commit/e32c430f526f1637ec5973c9723acbc5be571ae3.patch";
      sha256 = "0s4j5rb70g3jvvkgfbrxv7q52wk6yjyjiaya61gy2j64khplcjlb";
    })
  ];

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ opencascade ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++11" ];

  meta = with lib; {
    description = "Extension to OCE providing advanced meshing features";
    homepage = "https://github.com/tpaviot/smesh";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
