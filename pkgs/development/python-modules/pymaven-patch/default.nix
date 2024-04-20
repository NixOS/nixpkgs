{ lib
, fetchPypi
, buildPythonPackage
, pbr
, requests
, six
, lxml
, pytestCheckHook
, pytest-cov
, mock
}:
buildPythonPackage rec {
  pname = "pymaven-patch";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DPfJPonwHwQI62Vu7FjLSiKMleA7PUfLc9MfiZBVzVA=";
  };

  propagatedBuildInputs = [
    pbr
    requests
    six
    lxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    mock
  ];

  pythonImportsCheck = [
    "pymaven"
  ];

  meta = with lib; {
    description = "Python access to maven";
    homepage = "https://github.com/nexB/pymaven";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
