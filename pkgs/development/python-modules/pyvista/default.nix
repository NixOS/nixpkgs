{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, matplotlib
, numpy
, pillow
, pooch
, scooby
, vtk
}:

buildPythonPackage rec {
  pname = "pyvista";
<<<<<<< HEAD
  version = "0.42.1";
=======
  version = "0.39.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Bk2bw6WCLzMb3nLMCS9rRugNocA9eYju/aoE68TYu5c=";
=======
    hash = "sha256-PQOkwpyaKZ0oubDCzIKHXylpk1HWH39O0zonJ7Gfly4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    imageio
    matplotlib
    numpy
    pillow
    pooch
    scooby
    vtk
  ];

  # Fatal Python error: Aborted
  doCheck = false;

  pythonImportsCheck = [
    "pyvista"
  ];

  meta = with lib; {
    homepage = "https://pyvista.org";
    description = "Easier Pythonic interface to VTK";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
