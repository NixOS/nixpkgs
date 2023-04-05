{ lib, buildPythonPackage, fetchPypi, typing-extensions }:

buildPythonPackage rec {
  pname = "injector";
  version = "0.20.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hmG0mi+DCc5h46aoK3rLXiJcS96OF9FhDIk6Zw3/Ijo=";
  };

  propagatedBuildInputs = [ typing-extensions ];

  doCheck = false; # No tests are available
  pythonImportsCheck = [ "injector" ];

  meta = with lib; {
    description = "Python dependency injection framework, inspired by Guice";
    homepage = "https://github.com/alecthomas/injector";
    maintainers = [ maintainers.ivar ];
    license = licenses.bsd3;
  };
}
