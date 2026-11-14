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

buildPythonPackage (finalAttrs: {
  pname = "ansible-pylibssh";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ansible_pylibssh";
    inherit (finalAttrs) version;
    hash = "sha256-pItebbIQYrxiWFSOaj5DYwQ9QBKPDmt5Z3Slm2p9voI=";
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
    changelog = "https://github.com/ansible/pylibssh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ wfdewith ];
  };
})
