{
  lib,
  async-timeout,
  attrs,
  buildPythonPackage,
  faust-cchardet,
  fetchFromGitHub,
  httpx,
  orjson,
  packaging,
  pythonOlder,
  setuptools,
  typing-extensions,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "axis";
  version = "65";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "axis";
    tag = "v${version}";
    hash = "sha256-65njqnnahpYhx5CShjWOuNlkckQbt8tMjKf8OUCrmbw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==80.9.0" "setuptools" \
      --replace-fail "wheel==0.46.1" "wheel"
  '';

  build-system = [ setuptools ];

  dependencies = [
    async-timeout
    attrs
    faust-cchardet
    httpx
    orjson
    packaging
    typing-extensions
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
