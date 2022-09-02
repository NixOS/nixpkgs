{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hpack
, hyperframe
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "h2";
  version = "4.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qDrKCPvnqst5/seIycC6yTY0NWDtnsGLgqE6EsKNKrs=";
  };

  propagatedBuildInputs = [
    hpack
    hyperframe
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [
    "h2.connection"
    "h2.config"
  ];

  meta = with lib; {
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "https://github.com/python-hyper/h2";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
