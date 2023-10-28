{ lib
, buildPythonPackage
, fetchFromGitHub
, six
}:

buildPythonPackage rec {
  pname = "rouge";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pltrdy";
    repo = "rouge";
    rev = version;
    hash = "sha256-Xxq0N3mwy8+O8PrHNia9RovHS74+029Z+yhT7kdkLbk=";
  };

  pythonImportsCheck = [ "rouge" ];

  propagatedBuildInputs = [ six ];

  doCheck = false;

  meta = with lib; {
    description = "A full Python Implementation of the ROUGE Metric (not a wrapper)";
    homepage = "https://github.com/pltrdy/rouge";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
