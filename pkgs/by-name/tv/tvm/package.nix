{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tvm";
  version = "0.27.0.post1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tvm";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-7m5Ob4qUVJV3ABLXHhvXLKvI1I6ayf91PJCvFUG8KBI=";
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
