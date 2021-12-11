{ lib, buildPythonPackage, fetchFromGitHub, typing-extensions }:

buildPythonPackage rec {
  pname = "injector";
  version = "0.18.4";

  src = fetchFromGitHub {
     owner = "alecthomas";
     repo = "injector";
     rev = "0.18.4";
     sha256 = "1axn2sbimj8fyr4zjgxf569h9hq1xn6xqnmpfkfnnazy2im4nm9n";
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
