{ lib
, buildPythonPackage
, ddt
, fetchFromGitHub
, gitdb
, pkgs
, pythonOlder
, setuptools
, substituteAll
, typing-extensions
}:

buildPythonPackage rec {
  pname = "gitpython";
  version = "3.1.41";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gitpython-developers";
    repo = "GitPython";
    rev = "refs/tags/${version}";
    hash = "sha256-vVfY0/4NekysOUplj8xvyXRE8dJVQG0T83xISrNioE0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ddt
    gitdb
    pkgs.gitMinimal
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace git/cmd.py \
      --replace 'git_exec_name = "git"' 'git_exec_name = "${pkgs.gitMinimal}/bin/git"'
  '';

  # Tests require a git repo
  doCheck = false;

  pythonImportsCheck = [
    "git"
  ];

  meta = with lib; {
    description = "Python Git Library";
    homepage = "https://github.com/gitpython-developers/GitPython";
    changelog = "https://github.com/gitpython-developers/GitPython/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
