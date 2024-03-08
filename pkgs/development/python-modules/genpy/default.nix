{ lib
, buildPythonPackage
, fetchPypi
, pytools
, numpy
}:

buildPythonPackage rec {
  pname = "genpy";
  version = "2022.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FGZbQlUgbJjnuiDaKS/vVlraMVmFF1cAQk7S3aPWXx4=";
  };

  propagatedBuildInputs = [
    pytools
    numpy
  ];

  meta = with lib; {
    description = "C/C++ source generation from an AST";
    homepage = "https://github.com/inducer/genpy";
    license = licenses.mit;
    maintainers = [ ];
  };
}
