{ lib
, buildPythonPackage
, fetchPypi
, chardet
, pyyaml
, requests
, six
, semver
, pytest
, pytestcov
, pytestrunner
, sphinx
, openapi-spec-validator
}:

buildPythonPackage rec {
  pname = "prance";
  version = "0.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ffpfny3z8v3g0drirm27qafafbbvbc4h5k8v7yiwirnh0vn9v46";
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
    pytest
    pytestcov
    openapi-spec-validator
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "tests_require = dev_require," "tests_require = None,"
  '';

  # many tests require network connection
  doCheck = false;

  meta = with lib; {
    description = "Resolving Swagger/OpenAPI 2.0 and 3.0.0 Parser";
    homepage = "https://github.com/jfinkhaeuser/prance";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
