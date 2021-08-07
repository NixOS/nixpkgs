{ lib
, buildPythonPackage
, fetchPypi
, chardet
, pyyaml
, requests
, six
, semver
, pytestCheckHook
, pytest-cov
, pytest-runner
, openapi-spec-validator
}:

buildPythonPackage rec {
  pname = "prance";
  version = "0.21.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43ebe3a5b38f0c65c428427004c4d8ce8d7155ddad50610276c89c192680f138";
  };

  buildInputs = [
    pytest-runner
  ];

  propagatedBuildInputs = [
    chardet
    pyyaml
    requests
    six
    semver
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    openapi-spec-validator
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "tests_require = dev_require," "tests_require = None," \
      --replace "chardet~=4.0" "" \
      --replace "semver~=2.13" ""
    substituteInPlace setup.cfg \
      --replace "--cov-fail-under=90" ""
  '';

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
    homepage = "https://github.com/jfinkhaeuser/prance";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
