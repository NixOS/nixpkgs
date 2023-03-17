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
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d55b29bd4aeef3510904a12885eb6856b5bd48f3e29925a123461429f9ad85c0";
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
    maintainers = teams.determinatesystems.members;
  };
}
