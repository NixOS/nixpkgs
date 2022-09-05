{ lib
, buildPythonPackage
, click
, colorama
, configparser
, distro
, fetchFromGitHub
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
  version = "2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Fizzadar";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-nWH4o6NqyqkZg/HxF6NesnA6ijWo+B94BeohSsP60TY=";
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

  checkInputs = [
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
    longDescription = ''
      pyinfra automates/provisions/manages/deploys infrastructure. It can be used for
      ad-hoc command execution, service deployment, configuration management and more.
    '';
    homepage = "https://github.com/Fizzadar/pyinfra";
    maintainers = with maintainers; [ totoroot ];
    license = licenses.mit;
  };
}
