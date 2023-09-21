{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch-vcs
, hatchling
, httpx
, pytestCheckHook
, pythonOlder
, respx
}:

buildPythonPackage rec {
  pname = "iaqualink";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "flz";
    repo = "iaqualink-py";
    rev = "v${version}";
    hash = "sha256-ewPP2Xq+ecZGc5kokvLEsRokGqTWlymrzkwk480tapk=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    httpx
  ] ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    pytestCheckHook
    respx
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "pytest --cov-config=pyproject.toml --cov-report=xml --cov-report=term --cov=src --cov=tests" ""
  '';

  pythonImportsCheck = [
    "iaqualink"
  ];

  meta = with lib; {
    description = "Python library for Jandy iAqualink";
    homepage = "https://github.com/flz/iaqualink-py";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
