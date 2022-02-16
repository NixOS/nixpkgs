{ lib
, fetchPypi
, buildPythonPackage
, setuptools
}:

buildPythonPackage rec {
  pname = "limits";
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1CcNKVkcxezqsZvgU0VaTmGbo5UGJQK94rVoGvfcG+g=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  doCheck = false; # ifilter

  meta = with lib; {
    description = "Rate limiting utilities";
    homepage = "https://limits.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
