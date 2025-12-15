{
  lib,
  buildPythonPackage,
  ddt,
  fetchFromGitHub,
  gitdb,
  pkgs,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gitpython";
  version = "3.1.45";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gitpython-developers";
    repo = "GitPython";
    tag = version;
    hash = "sha256-VHnuHliZEc/jiSo/Zi9J/ipAykj7D6NttuzPZiE8svM=";
  };

  postPatch = ''
    substituteInPlace git/cmd.py \
      --replace 'git_exec_name = "git"' 'git_exec_name = "${pkgs.gitMinimal}/bin/git"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    ddt
    gitdb
    pkgs.gitMinimal
  ];

  # Tests require a git repo
  doCheck = false;

  pythonImportsCheck = [ "git" ];

  meta = {
    description = "Python Git Library";
    homepage = "https://github.com/gitpython-developers/GitPython";
    changelog = "https://github.com/gitpython-developers/GitPython/blob/${src.tag}/doc/source/changes.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
