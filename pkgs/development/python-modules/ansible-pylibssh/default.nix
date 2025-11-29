{
  lib,
  buildPythonPackage,
  cython,
  expandvars,
  fetchPypi,
  libssh,
  pythonOlder,
  setuptools,
  setuptools-scm,
  toml,
  wheel,
}:

buildPythonPackage rec {
  pname = "ansible-pylibssh";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JD6hsJYrC2secXrA5p2sljbmHsZbNyYMMXsjYMbjDKc=";
  };

  # Remove after https://github.com/ansible/pylibssh/pull/502 is merged
  postPatch = ''
    sed -i "/setuptools_scm_git_archive/d" pyproject.toml
  '';

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

  meta = with lib; {
    description = "Python bindings to client functionality of libssh specific to Ansible use case";
    homepage = "https://github.com/ansible/pylibssh";
    changelog = "https://github.com/ansible/pylibssh/releases/tag/v${version}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ geluk ];
  };
}
