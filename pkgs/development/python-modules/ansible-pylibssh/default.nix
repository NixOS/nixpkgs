{
  lib,
  buildPythonPackage,
  cython,
  expandvars,
  fetchPypi,
  libssh,
  setuptools,
  setuptools-scm,
  toml,
  wheel,
}:

buildPythonPackage rec {
  pname = "ansible-pylibssh";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JD6hsJYrC2secXrA5p2sljbmHsZbNyYMMXsjYMbjDKc=";
  };

  build-system = [
    cython
    expandvars
    setuptools
    setuptools-scm
    toml
    wheel
  ];

  dependencies = [ libssh ];

  pythonImportsCheck = [ "pylibsshext" ];

  meta = {
    description = "Python bindings to client functionality of libssh specific to Ansible use case";
    homepage = "https://github.com/ansible/pylibssh";
    changelog = "https://github.com/ansible/pylibssh/releases/tag/v${version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ wfdewith ];
  };
}
