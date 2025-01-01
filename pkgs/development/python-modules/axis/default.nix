{
  lib,
  async-timeout,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  orjson,
  packaging,
  pythonOlder,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "axis";
  version = "64";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "axis";
    rev = "refs/tags/v${version}";
    hash = "sha256-6g4Dqk+oGlEcqlNuMiwep+NCVFmwRZjKgEZC1OzmKw0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==75.6.0" "setuptools" \
      --replace-fail "wheel==0.45.1" "wheel"
  '';

  build-system = [ setuptools ];

  dependencies = [
    async-timeout
    attrs
    httpx
    orjson
    packaging
    xmltodict
  ];

  # Tests requires a server on localhost
  doCheck = false;

  pythonImportsCheck = [ "axis" ];

  meta = with lib; {
    description = "Python library for communicating with devices from Axis Communications";
    homepage = "https://github.com/Kane610/axis";
    changelog = "https://github.com/Kane610/axis/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "axis";
  };
}
