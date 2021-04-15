{ lib, stdenv, version, fetch, cmake, llvm
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation {
  pname = "libunwind";
  inherit version;

  src = fetch "libunwind" "035dsxs10nyiqd00q07yycvmkjl01yz4jdlrjvmch8klxg4pyjhp";

  nativeBuildInputs = [ cmake llvm ];

  cmakeFlags = lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF"
    ++ [ "-DLIBUNWIND_STANDALONE_BUILD=ON" ];
}
