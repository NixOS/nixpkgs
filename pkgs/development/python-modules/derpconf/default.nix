{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "derpconf";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-66MOqcWIiqJrORJDgAH5iUblHyqJvuf9DIBN56XjKwU=";
  };

  propagatedBuildInputs = [
    six
  ];

  pythonImportsCheck = [
    "derpconf"
  ];

  meta = with lib; {
    description = "Module to abstract loading configuration files for your app";
    homepage = "https://github.com/globocom/derpconf";
    changelog = "https://github.com/globocom/derpconf/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
