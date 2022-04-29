{ lib, buildPythonPackage, fetchPypi, typing-extensions }:

buildPythonPackage rec {
  pname = "injector";
  version = "0.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3eaaf51cd3ba7be1354d92a5210c8bba43dd324300eafd214e1f2568834a912f";
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
