{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
<<<<<<< HEAD

# build
, poetry-core

# propagates
, pathable
, pyyaml
, referencing
, requests

# tests
, pytestCheckHook
, responses
=======
, poetry-core
, jsonschema
, pathable
, pyyaml
, typing-extensions
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jsonschema-spec";
<<<<<<< HEAD
  version = "0.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.1.4";
  format = "pyproject";
  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Sa97DwPnGMLmT00hVdkoGO7C0vrvtwxvUvv9lq4nCY4=";
  };

  postPatch = ''
    sed -i "/^--cov/d" pyproject.toml

    substituteInPlace pyproject.toml \
      --replace 'referencing = ">=0.28.0,<0.30.0"' 'referencing = ">=0.28.0"'
=======
    hash = "sha256-kLCV9WPWGrVgpbueafMVqtGmj3ifrBzTChE2kyxpyZk=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    pathable
    pyyaml
    referencing
    requests
=======
    jsonschema
    pathable
    pyyaml
    typing-extensions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
    responses
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    changelog = "https://github.com/p1c2u/jsonschema-spec/releases/tag/${version}";
    description = "JSONSchema Spec with object-oriented paths";
    homepage = "https://github.com/p1c2u/jsonschema-spec";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
