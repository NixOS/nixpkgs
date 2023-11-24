{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, libssh
, cython
, wheel
, setuptools
, setuptools-scm
, toml
, expandvars
}:

buildPythonPackage rec {
  pname = "ansible-pylibssh";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-spaGux6dYvtUtpOdU6oN7SEn8IgBof2NpQSPvr+Zplg=";
  };

  # remove after https://github.com/ansible/pylibssh/pull/502 is merged
  postPatch = ''
    sed -i "/setuptools_scm_git_archive/d" pyproject.toml
  '';

  nativeBuildInputs = [
    cython
    wheel
    setuptools
    setuptools-scm
    toml
    expandvars
  ];

  propagatedBuildInputs = [
    libssh
  ];

  pythonImportsCheck = [
    "pylibsshext"
  ];

  meta = with lib; {
    description = "Python bindings to client functionality of libssh specific to Ansible use case";
    homepage = "https://github.com/ansible/pylibssh";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ geluk ];
  };
}
