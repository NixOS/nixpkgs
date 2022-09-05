{ lib, buildPythonPackage, fetchPypi, click, sortedcontainers, pyyaml }:

buildPythonPackage rec {
  pname = "cock";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-B6r6+b+x5vEp4+yfhV03dfjlVjRbW2W6Pm91PC0Tb+o=";
  };

  propagatedBuildInputs = [ click sortedcontainers pyyaml ];

  meta = with lib; {
    homepage = "https://github.com/pohmelie/cock";
    description = "Configuration file with click";
    license = licenses.mit;
  };
}
