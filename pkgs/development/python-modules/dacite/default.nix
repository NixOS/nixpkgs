{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dacite";
<<<<<<< HEAD
  version = "1.8.1";
=======
  version = "1.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "konradhalas";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-lvObQ+jyBH2s4GOwyDXEAYmG7ZGQN9WDqL8ftNItPCQ=";
=======
    hash = "sha256-aQwQHFWaXwTaA6GQgDcWT6ivE9YtWtHCTOtxDi503+M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--benchmark-autosave --benchmark-json=benchmark.json" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dacite"
  ];

  disabledTestPaths = [
    "tests/performance"
  ];

  meta = with lib; {
    description = "Python helper to create data classes from dictionaries";
    homepage = "https://github.com/konradhalas/dacite";
    changelog = "https://github.com/konradhalas/dacite/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
