{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  six,
}:

buildPythonPackage rec {
  pname = "scales";
  version = "1.0.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i2kw99S/EVGSKQtEx1evXiVOP8/Ldf+aUfXJakBOJ1M=";
  };

  nativeCheckInputs = [ nose ];
  propagatedBuildInputs = [ six ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Stats for Python processes";
    homepage = "https://www.github.com/Cue/scales";
    license = licenses.asl20;
  };
}
