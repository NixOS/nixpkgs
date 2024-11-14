{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  dulwich,
  mercurial,
  pythonOlder,
  unzip,
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "1.1.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "hg_git";
    inherit version;
    hash = "sha256-lqnCi4MjdPVCIXdYAIDGdRY5zcU5QPrSHzy+NKysMtc=";
  };

  pythonRelaxDeps = [
    "dulwich"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dulwich
    mercurial
  ];

  pythonImportsCheck = [ "hggit" ];

  nativeBuildInputs = [
    unzip
  ];

  checkPhase = ''
    runHook preCheck

    patchShebangs .
    pushd tests
    ./run-tests.py
    popd

    runHook postCheck
  '';

  meta = {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ koral ];
  };
}
