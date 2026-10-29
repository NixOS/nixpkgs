{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "bytes";
  version = "2018-02-10";

  src = fetchFromGitHub {
    owner = "ziman";
    repo = "idris-bytes";
    rev = "c0ed9db526d4529780f9d7d2636a40faa07661a5";
    hash = "sha256-1zX0MzvfsZhySn93SqTxbmm1Od5PZFmcrLHMXME8y/c=";
  };

  meta = {
    description = "FFI-based byte buffers for Idris";
    homepage = "https://github.com/ziman/idris-bytes";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
