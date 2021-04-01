{ lib, stdenv, version, fetch, libcxx, llvm, cmake
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  src = fetch pname "18n3k2kf6pyvzspnz1i22czbgi14kmch76fxml8kvhky7mw7v1yz";

  postUnpack = ''
    unpackFile ${libcxx.src}
    mv libcxx-* libcxx
    unpackFile ${llvm.src}
    mv llvm-* llvm
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF";
}
