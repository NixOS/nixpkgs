{ lib, buildPythonPackage, fetchPypi, typing-extensions }:

buildPythonPackage rec {
  pname = "injector";
  version = "0.18.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10miwi58g4b8rvdf1pl7s7x9j91qyxxv3kdn5idzkfc387hqxn6f";
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
