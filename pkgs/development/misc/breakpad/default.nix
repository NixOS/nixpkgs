{ lib, stdenv, fetchgit }:
let
  lss = fetchgit {
    url = "https://chromium.googlesource.com/linux-syscall-support";
    rev = "d9ad2969b369a9f1c455fef92d04c7628f7f9eb8";
    sha256 = "952dv+ZE1ge/WF5RyHmEqht+AofoRHKAeFmGasVF9BA=";
  };
in stdenv.mkDerivation {
  pname = "breakpad";

  version = "unstable-3b3469e";

  src = fetchgit {
    url = "https://chromium.googlesource.com/breakpad/breakpad";
    rev = "3b3469e9ed0de3d02e4450b9b95014a4266cf2ff";
    sha256 = "bRGOBrGPK+Zxp+KK+E5MFkYlDUNVhVeInVSwq+eCAF0=";
  };

  postUnpack = ''
    ln -s ${lss} $sourceRoot/src/third_party/lss
  '';

  postPatch = ''
    substituteInPlace src/client/linux/handler/exception_handler.cc \
      --replace "max(16384" "max(static_cast<long>(16384)"
  '';

  meta = with lib; {
    description = "An open-source multi-platform crash reporting system";
    homepage = "https://chromium.googlesource.com/breakpad";
    license = licenses.bsd3;
    maintainers = with maintainers; [ berberman ];
    platforms = platforms.all;
  };
}
