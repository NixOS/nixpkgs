{ lib, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "limits";
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1CcNKVkcxezqsZvgU0VaTmGbo5UGJQK94rVoGvfcG+g=";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false; # ifilter

  meta = with lib; {
    description = "Rate limiting utilities";
    license = licenses.mit;
    homepage = "https://limits.readthedocs.org/";
  };
}
