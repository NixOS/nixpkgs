{ lib
, buildPythonPackage
, fetchPypi
, chardet
, pyyaml
, requests
, six
, semver
, pytestCheckHook
, pytestcov
, pytestrunner
, openapi-spec-validator
}:

buildPythonPackage rec {
  pname = "prance";
  version = "0.20.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ffcddae6218cf6753a02af36ca9fb1c92eec4689441789ee2e9963230882388";
  };

  buildInputs = [
    pytestrunner
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
    pytestcov
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
