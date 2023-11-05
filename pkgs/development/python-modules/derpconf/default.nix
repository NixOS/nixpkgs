{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "derpconf";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-66MOqcWIiqJrORJDgAH5iUblHyqJvuf9DIBN56XjKwU=";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "derpconf abstracts loading configuration files for your app";
    homepage = "https://github.com/globocom/derpconf";
    license = licenses.mit;
  };
}
