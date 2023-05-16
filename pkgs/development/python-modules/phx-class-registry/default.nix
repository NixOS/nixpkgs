{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "class-registry";
  version = "4.0.6";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "todofixthis";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kSEHgzBgnAq5rMv2HbmGl+9CUzsmzUzPQWr+5q8mcsA=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "class_registry"
  ];

  meta = with lib; {
    description = "Factory and registry pattern for Python classes";
    homepage = "https://class-registry.readthedocs.io/en/latest/";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ kevincox ];
=======
    maintainers = with maintainers; [ kevincox SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
