{ lib
, buildPythonPackage
, fetchPypi
, werkzeug
}:

buildPythonPackage rec {
  pname = "pytest-localserver";
  version = "0.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef6f04193dc0f7e8df5b27b3a8834318fa12eaf025436d2a99afff1b73cde761";
  };

  propagatedBuildInputs = [
    werkzeug
  ];

  # all tests access network: does not work in sandbox
  doCheck = false;

  pythonImportsCheck = [
    "pytest_localserver"
  ];

  meta = with lib; {
    description = "Plugin for the pytest testing framework to test server connections locally";
    homepage = "https://github.com/pytest-dev/pytest-localserver";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
