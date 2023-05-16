{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, python
, cffi
, pytestCheckHook
, pythonOlder
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "pymunk";
<<<<<<< HEAD
  version = "6.5.1";
=======
  version = "6.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-ZEO7YJBkCMgsD9MnwBn/X3qt39+IiecM453bjDgZDls=";
=======
    hash = "sha256-YNzZ/wQz5s5J5ctXekNo0FksRoX03rZE1wXIghYcck4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cffi
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    ApplicationServices
  ];

  preBuild = ''
    ${python.pythonForBuild.interpreter} setup.py build_ext --inplace
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "pymunk/tests"
  ];

  pythonImportsCheck = [
    "pymunk"
  ];

  meta = with lib; {
    description = "2d physics library";
    homepage = "https://www.pymunk.org";
    changelog = "https://github.com/viblo/pymunk/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
