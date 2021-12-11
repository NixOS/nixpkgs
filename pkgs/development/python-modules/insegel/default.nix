{ lib, buildPythonPackage, fetchFromGitHub, pygments }:

buildPythonPackage rec {
  pname = "insegel";
  version = "1.3.1";

  src = fetchFromGitHub {
     owner = "autophagy";
     repo = "insegel";
     rev = "1.3.1";
     sha256 = "1af61ziqy32bklaa56f1fmhvsmvjmhjf5sdj0znqlawbwsnayavd";
  };

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [
    "insegel"
  ];

  meta = with lib; {
    homepage = "https://github.com/autophagy/insegel";
    description = "A monochrome 2 column Sphinx theme";
    license = licenses.mit;
    maintainers = with maintainers; [ autophagy ];
  };
}
