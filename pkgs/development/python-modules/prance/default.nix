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
  version = "0.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7e98b0f7e8ef0dd581c40d8a3e869e15e74b08026b862c3212447f8aa2426a7";
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
