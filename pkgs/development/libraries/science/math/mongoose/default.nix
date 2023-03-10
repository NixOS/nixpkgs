{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "mongoose";
  version = "2.0.4";

  outputs = [ "bin" "out" "dev" ];

  src = fetchFromGitHub {
    owner = "ScottKolo";
    repo = "Mongoose";
    rev = "v${version}";
    sha256 = "0ymwd4n8p8s0ndh1vcbmjcsm0x2cc2b7v3baww5y6as12873bcrh";
  };

  patches = [
    # TODO: remove on next release
    (fetchpatch {
      name = "add-an-option-to-disable-coverage.patch";
      url = "https://github.com/ScottKolo/Mongoose/commit/39f4a0059ff7bad5bffa84369f31839214ac7877.patch";
      sha256 = "sha256-V8lCq22ixCCzLmKtW6bUL8cvJFZzdgYoA4BFs4xYd3c=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  # ld: file not found: libclang_rt.profile_osx.a
  cmakeFlags = lib.optional (stdenv.isDarwin && stdenv.isAarch64) "-DENABLE_COVERAGE=OFF";

  meta = with lib; {
    description = "Graph Coarsening and Partitioning Library";
    homepage = "https://github.com/ScottKolo/Mongoose";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wegank ];
    platforms = with platforms; unix;
  };
}
