{
  lib,
  buildPythonPackage,
  cython,
  expandvars,
  fetchFromGitHub,
  pep517,
  pytestCheckHook,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "frozenlist";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "frozenlist";
    tag = "v${version}";
    hash = "sha256-vkZ60qI0yQ82QSLQkBDzLnikTBQhUUuAzV+YsorrM2Q=";
  };

  postPatch = ''
    rm pytest.ini
  '';

  nativeBuildInputs = [
    expandvars
    cython
    pep517
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preBuild = ''
    cython frozenlist/_frozenlist.pyx
  '';

  pythonImportsCheck = [ "frozenlist" ];

  meta = {
    description = "Python module for list-like structure";
    homepage = "https://github.com/aio-libs/frozenlist";
    changelog = "https://github.com/aio-libs/frozenlist/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
