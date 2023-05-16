{ lib
, attrs
, buildPythonPackage
, cattrs
, fetchFromGitHub
, flit-core
, jsonschema
, nox
, pyhamcrest
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "lsprotocol";
<<<<<<< HEAD
  version = "2023.0.0a2";
=======
  version = "2023.0.0a1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-AEvs2fb8nhWEFMyLvwNv9HoxxxE50/KW3TGZ5pDf4dc=";
=======
    hash = "sha256-gfsqn9NtO7meMks4dUhrTYVlr69Ffh339GD9FvCJvJM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    flit-core
    nox
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkInputs = [
    jsonschema
    pyhamcrest
  ];

  preBuild = ''
    cd packages/python
  '';

  preCheck = ''
    cd ../../
  '';

  checkPhase = ''
    runHook preCheck

    sed -i "/^    _install_requirements/d" noxfile.py
    nox --session tests

    runHook postCheck
  '';

  pythonImportsCheck = [
    "lsprotocol"
  ];

  meta = with lib; {
    description = "Python implementation of the Language Server Protocol";
    homepage = "https://github.com/microsoft/lsprotocol";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar fab ];
  };
}
