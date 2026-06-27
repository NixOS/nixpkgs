{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tvm";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-tvm";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-4y/QogNHDkyZ7wdxmxxVLp77Qowuuqd6O2sdlcJD5qs=";
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
