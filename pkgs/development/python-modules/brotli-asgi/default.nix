{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build inputs
  starlette,
  brotli,
  # check inputs
  httpx,
  requests,
  mypy,
  brotlipy,
}:
let
  pname = "brotli-asgi";
  version = "1.6.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fullonic";
    repo = "brotli-asgi";
    rev = "v${version}";
    hash = "sha256-cF7A3mnkQmvtc9DgHiwqYEQQ6QagjoBGTmcBzUm6vvs=";
  };

  propagatedBuildInputs = [
    starlette
    brotli
  ];

  pythonImportsCheck = [ "brotli_asgi" ];

  nativeCheckInputs = [
    httpx
    requests
    mypy
    brotlipy
  ];

  meta = {
    description = "Compression AGSI middleware using brotli";
    homepage = "https://github.com/fullonic/brotli-asgi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
