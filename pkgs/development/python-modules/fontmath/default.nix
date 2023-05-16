<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, fonttools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fontmath";
  version = "0.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "fontMath";
    inherit version;
=======
{ lib, buildPythonPackage, fetchPypi, isPy27
, fonttools, setuptools-scm
, pytest, pytest-runner
}:

buildPythonPackage rec {
  pname = "fontMath";
  version = "0.9.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hash = "sha256-alOHy3/rEFlY2y9c7tyHhRPMNb83FeJiCQ8FV74MGxw=";
    extension = "zip";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fonttools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
=======
  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ fonttools ];
  nativeCheckInputs = [ pytest pytest-runner ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A collection of objects that implement fast font, glyph, etc. math";
    homepage = "https://github.com/robotools/fontMath/";
<<<<<<< HEAD
    changelog = "https://github.com/robotools/fontMath/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
=======
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
