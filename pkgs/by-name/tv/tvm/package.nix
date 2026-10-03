{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tvm";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tvm";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-+2F1q9He2u5jdfYUyKWUlKhGoViChPUdYEow1PVKOF4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://tvm.apache.org/";
    description = "End to End Deep Learning Compiler Stack for CPUs, GPUs and accelerators";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ adelbertc ];
  };
})
