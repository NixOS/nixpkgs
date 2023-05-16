{ lib
, buildPythonPackage
, fetchPypi
, pytools
, numpy
}:

buildPythonPackage rec {
  pname = "genpy";
  version = "2022.1";

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
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
