<<<<<<< HEAD
{ stdenv, lib, buildPythonPackage, fetchPypi, pythonRelaxDepsHook, pillow, regex }:
=======
{ stdenv, lib, buildPythonPackage, fetchPypi, pillow, regex }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "material-color-utilities-python";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PG8C585wWViFRHve83z3b9NijHyV+iGY2BdMJpyVH64=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];
  pythonRelaxDeps = [
    "Pillow"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    pillow
    regex
  ];

  # No tests implemented.
  doCheck = false;

  pythonImportsCheck = [ "material_color_utilities_python" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/material_color_utilities_python";
    description = "Python port of material_color_utilities used for Material You colors";
    license = licenses.asl20;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
