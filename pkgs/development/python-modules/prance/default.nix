{ lib
, buildPythonPackage
, fetchFromGitHub
, chardet
, requests
, ruamel-yaml
, setuptools-scm
, six
, semver
, pytestCheckHook
, openapi-spec-validator
}:

buildPythonPackage rec {
  pname = "prance";
  version = "0.21.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "RonnyPfannschmidt";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-kGANMHfWwhW3ZBw2ZVCJZR/bV2EPhcydMKhDeDTVwcQ=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=prance --cov-report=term-missing --cov-fail-under=90" "" \
      --replace "chardet>=3.0,<5.0" "chardet"
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    chardet
    requests
    ruamel-yaml
    six
    semver
  ];

  checkInputs = [
    pytestCheckHook
    openapi-spec-validator
  ];

  # Disable tests that require network
  disabledTestPaths = [
    "tests/test_convert.py"
  ];
  disabledTests = [
    "test_fetch_url_http"
  ];
  pythonImportsCheck = [ "prance" ];

  meta = with lib; {
    description = "Resolving Swagger/OpenAPI 2.0 and 3.0.0 Parser";
    homepage = "https://github.com/RonnyPfannschmidt/prance";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
