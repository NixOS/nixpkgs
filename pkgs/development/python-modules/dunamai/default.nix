{ lib
, poetry-core
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, importlib-metadata
, packaging
, pytestCheckHook
<<<<<<< HEAD
=======
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, git
}:

buildPythonPackage rec {
  pname = "dunamai";
<<<<<<< HEAD
  version = "1.18.0";
=======
  version = "1.16.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "dunamai";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-QKXEFwOAa5nIQZA6DHNqnWyshnN+/6qovdqjCd9WF4k=";
=======
    hash = "sha256-pPUn+1rv76N/7WVDyWJLPVMweJ1Qbx6/P4zIKU06hSs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # needs to be able to run dunami from PATH
  preCheck = ''
    export PATH=$PATH:$out/bin
    export HOME=$(mktemp -d)

    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"
  '';

  nativeCheckInputs = [
    git
    pytestCheckHook
<<<<<<< HEAD
  ];

  disabledTests = [
    # clones from github.com
    "test__version__from_git__shallow"
=======
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "dunamai"
  ];

  meta = with lib; {
    description = "Dynamic version generation";
    homepage = "https://github.com/mtkennerly/dunamai";
    changelog = "https://github.com/mtkennerly/dunamai/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman ];
  };
}
