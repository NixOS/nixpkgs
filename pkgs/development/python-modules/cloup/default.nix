{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, click
, setuptools-scm
, pythonOlder
<<<<<<< HEAD
, typing-extensions
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "cloup";
<<<<<<< HEAD
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4ItMwje7mlvY/4G6btSUmOIgDaw5InsWSOlXiCAo6ZM=";
=======
  version = "2.0.0.post1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FDDJB1Bi4Jy2TNhKt6/l1azSit9WHWqzEJ6xl1u9e2s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
<<<<<<< HEAD
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "cloup"
  ];
=======
  pythonImportsCheck = [ "cloup" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/janLuke/cloup";
    description = "Click extended with option groups, constraints, aliases, help themes";
<<<<<<< HEAD
    changelog = "https://github.com/janluke/cloup/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      Enriches Click with option groups, constraints, command aliases, help sections for subcommands, themes for --help and other stuff.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ friedelino ];
  };
}
