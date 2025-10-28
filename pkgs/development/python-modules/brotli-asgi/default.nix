{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  version = "1.5.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fullonic";
    repo = "brotli-asgi";
    rev = "v${version}";
    hash = "sha256-jOow5xrRvuBdg/dVEzAUgs1SxNLZqEItyW9OcvniTSY=";
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

  meta = with lib; {
    description = "Compression AGSI middleware using brotli";
    homepage = "https://github.com/fullonic/brotli-asgi";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
