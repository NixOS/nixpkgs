{ lib
, poetry-core
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, importlib-metadata
, packaging
, pytestCheckHook
, setuptools
, git
}:

buildPythonPackage rec {
  pname = "dunamai";
  version = "1.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "dunamai";
    rev = "refs/tags/v${version}";
    hash = "sha256-pPUn+1rv76N/7WVDyWJLPVMweJ1Qbx6/P4zIKU06hSs=";
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
    setuptools
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
