{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitdb,
  gitMinimal,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "gitpython";
  version = "3.1.58";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gitpython-developers";
    repo = "GitPython";
    tag = finalAttrs.version;
    hash = "sha256-C6hrN7SRWngwkD/NYvsoEVQUagdurkxzWbnn42EJOHE=";
  };

  postPatch = ''
    substituteInPlace git/cmd.py \
      --replace-fail 'git_exec_name = "git"' 'git_exec_name = "${lib.getExe gitMinimal}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    gitdb
  ];

  # Tests require a git repo
  doCheck = false;

  pythonImportsCheck = [ "git" ];

  meta = {
    description = "Python Git Library";
    homepage = "https://github.com/gitpython-developers/GitPython";
    changelog = "https://github.com/gitpython-developers/GitPython/blob/${finalAttrs.src.tag}/doc/source/changes.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
