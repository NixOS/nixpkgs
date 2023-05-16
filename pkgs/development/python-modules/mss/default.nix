{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mss";
<<<<<<< HEAD
  version = "9.0.1";
=======
  version = "7.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-bre5AIzydCiBH6M66zXzM024Hj98wt1J7HxuWpSznxI=";
  };

  prePatch = ''
    # By default it attempts to build Windows-only functionality
    rm src/mss/windows.py
  '';

  # Skipping tests due to most relying on DISPLAY being set
  doCheck = false;

=======
    hash = "sha256-8UzuUokDw7AdO48SCc1JhCL3Hj0NLZLFuTPt07l3ICI=";
  };

  # By default it attempts to build Windows-only functionality
  prePatch = ''
    rm mss/windows.py
  '';

  # Skipping tests due to most relying on DISPLAY being set
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "mss"
  ];

  meta = with lib; {
    description = "Cross-platform multiple screenshots module";
    homepage = "https://github.com/BoboTiG/python-mss";
<<<<<<< HEAD
    changelog = "https://github.com/BoboTiG/python-mss/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ austinbutler ];
  };
}
