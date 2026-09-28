{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tvm";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tvm";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-sUVD2vrYh/kC5V+70Xa70e0LJLa7lk+DcFfQdxX6w6g=";
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
