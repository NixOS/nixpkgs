{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, flit-core
<<<<<<< HEAD
, installer
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mock
}:

buildPythonPackage rec {
  pname = "installer";
  version = "0.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
<<<<<<< HEAD
    owner = "pypa";
=======
    owner = "pradyunsg";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    repo = pname;
    rev = version;
    hash = "sha256-thHghU+1Alpay5r9Dc3v7ATRFfYKV8l9qR0nbGOOX/A=";
  };

  nativeBuildInputs = [ flit-core ];

<<<<<<< HEAD
  # We need to disable tests because this package is part of the bootstrap chain
  # and its test dependencies cannot be built yet when this is being built.
  doCheck = false;

  passthru.tests = {
    pytest = buildPythonPackage {
      pname = "${pname}-pytest";
      inherit version;
      format = "other";

      dontBuild = true;
      dontInstall = true;

      nativeCheckInputs = [
        installer
        mock
        pytestCheckHook
      ];
    };
  };

  meta = with lib; {
    description = "A low-level library for installing a Python package from a wheel distribution";
    homepage = "https://github.com/pypa/installer";
    changelog = "https://github.com/pypa/installer/blob/${src.rev}/docs/changelog.md";
    license = licenses.mit;
    maintainers = teams.python.members ++ [ maintainers.cpcloud ];
=======
  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  meta = with lib; {
    changelog = "https://github.com/pypa/installer/blob/${src.rev}/docs/changelog.md";
    homepage = "https://github.com/pradyunsg/installer";
    description = "A low-level library for installing a Python package from a wheel distribution";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud fridh ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
