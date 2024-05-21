{ lib
, buildPythonPackage
, click
, colorama
, configparser
, distro
, fetchFromGitHub
, fetchpatch
, gevent
, jinja2
, paramiko
, pytestCheckHook
, python-dateutil
, pythonOlder
, pywinrm
, pyyaml
, setuptools
}:

buildPythonPackage rec {
  pname = "pyinfra";
  version = "2.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Fizzadar";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-lzbFwAg1aLCfBnSnqq4oVteArpkRBa7hU8V3vB5ODa8=";
  };

  propagatedBuildInputs = [
    click
    colorama
    configparser
    distro
    gevent
    jinja2
    paramiko
    python-dateutil
    pywinrm
    pyyaml
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyinfra"
  ];

  disabledTests = [
    # Test requires SSH binary
    "test_load_ssh_config"
  ];

  meta = with lib; {
    description = "Python-based infrastructure automation";
    mainProgram = "pyinfra";
    longDescription = ''
      pyinfra automates/provisions/manages/deploys infrastructure. It can be used for
      ad-hoc command execution, service deployment, configuration management and more.
    '';
    homepage = "https://pyinfra.com";
    downloadPage = "https://pyinfra.com/Fizzadar/pyinfra/releases";
    changelog = "https://github.com/Fizzadar/pyinfra/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ totoroot ];
    license = licenses.mit;
  };
}
