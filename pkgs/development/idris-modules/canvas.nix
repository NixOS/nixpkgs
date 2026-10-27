{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "canvas";
  version = "2017-11-09";

  ipkgName = "idriscanvas";

  src = fetchFromGitHub {
    owner = "JinWuZhao";
    repo = "idriscanvas";
    rev = "2957c78c0721ec3afaee9d64e051a8f8d9b6f426";
    hash = "sha256-3itwFg8Yxoq8Cc82XHMAqixAIKvObFEvvEGOHRmeOUo=";
  };

  meta = {
    description = "Idris FFI binding for html5 canvas 2d api";
    homepage = "https://github.com/JinWuZhao/idriscanvas";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
