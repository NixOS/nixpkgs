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
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a128d0d5f639a6a19eefedd787a6ce9603634c3908927b1215653e4a8375195f";
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
    homepage = https://github.com/jfinkhaeuser/prance;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
