{ lib
, pkgs
, python3Packages
, podman
, oniguruma
, fetchPypi
, buildPythonPackage
}:
buildPythonPackage rec {
  pname = "ansible-navigator";
  version = "24.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qXBhM63fFwPwo0pmEhZnZnGC8Eht8eFPfVbDkY98MGM=";
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
    # upper version limit on setuptools and setuptools-scm-git-archive aren't required
    sed -i 's/, <=[0-9.]*//g' pyproject.toml
    sed -i '/git_archive/d' pyproject.toml
  '';

  meta = with lib; {
    description = "A text-based user interface (TUI) for Ansible.";
    homepage = "https://ansible.readthedocs.io/projects/navigator/";
    license = licenses.asl20;
    maintainers = with maintainers; [ melkor333 ];
  };
}
