{ lib, buildPythonPackage, fetchPypi, typing-extensions }:

buildPythonPackage rec {
  pname = "injector";
  version = "0.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DILe3I4TVOj9Iqs9mbiL3e9t7bnHfWwixNids9FYN/U=";
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
