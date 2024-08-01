{
  lib,
  pkgs,
  python3Packages,
  podman,
  fetchPypi,
  buildPythonPackage,
}:
buildPythonPackage rec {
  pname = "ansible-navigator";
  version = "24.3.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IAcZFisB3BOmdxZuGZ3PZcDl2CXsg6ToI/1fdPpkIXw=";
  };

  buildInputs = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    ansible-builder
    ansible-runner
    podman
    pkgs.ansible-lint
    jinja2
    jsonschema
    tzdata
    onigurumacffi
  ];

  patchPhase = ''
    # scm_git_archive doesn't exist anymore. Fixed upstream but unreleased
    # Rev: https://github.com/ansible/ansible-navigator/pull/1716
    sed -i '/setuptools_scm_git_archive/d' pyproject.toml
  '';

  meta = with lib; {
    description = "Text-based user interface (TUI) for Ansible";
    homepage = "https://ansible.readthedocs.io/projects/navigator/";
    license = licenses.asl20;
    maintainers = with maintainers; [ melkor333 ];
  };
}
