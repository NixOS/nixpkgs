{ lib, stdenv, version, fetch, libcxx, llvm, cmake
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  src = fetch pname "0kaq75ygzv9dqfsx27pi5a0clipdjq6a9vghhb89d8k1rf20lslh";

  postUnpack = ''
    unpackFile ${libcxx.src}
    mv libcxx-* libcxx
    unpackFile ${llvm.src}
    mv llvm-* llvm
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF";
}
