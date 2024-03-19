{ lib
, async-timeout
, attrs
, buildPythonPackage
, fetchFromGitHub
, httpx
, orjson
, packaging
, pythonOlder
, setuptools
, xmltodict
}:

buildPythonPackage rec {
  pname = "axis";
  version = "56";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "axis";
    rev = "refs/tags/v${version}";
    hash = "sha256-vHdLDqNCErP5Wf9HYJP0X2S3mFbXB7ouBxoKwBtfVL4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==68.0.0" "setuptools" \
      --replace-fail "wheel==0.40.0" "wheel"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    async-timeout
    attrs
    httpx
    orjson
    packaging
    xmltodict
  ];

  # Tests requires a server on localhost
  doCheck = false;

  pythonImportsCheck = [
    "axis"
  ];

  meta = with lib; {
    description = "Python library for communicating with devices from Axis Communications";
    mainProgram = "axis";
    homepage = "https://github.com/Kane610/axis";
    changelog = "https://github.com/Kane610/axis/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
