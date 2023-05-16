{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "pyutilib";
  version = "6.0.0";

  src = fetchPypi {
    pname = "PyUtilib";
    inherit version;
    hash = "sha256-08FPjtkCioMbK/Ubird3brqH5mz8WKBrmcNZqqZA8EA=";
  };

  propagatedBuildInputs = [
    nose
    six
  ];

  # tests require text files that are not included in the pypi package
  doCheck = false;

  meta = with lib; {
    description = "PyUtilib: A collection of Python utilities";
    homepage = "https://github.com/PyUtilib/pyutilib";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
