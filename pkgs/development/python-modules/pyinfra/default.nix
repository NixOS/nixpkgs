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
  version = "2.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Fizzadar";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BYd2UYQJD/HsmpnlQjZvjfg17ShPuA3j4rtv6fTQK/A=";
  };

  patches = [
    # https://github.com/Fizzadar/pyinfra/pull/1018
    (fetchpatch {
      name = "bump-paramiko-major-version.patch";
      url = "https://github.com/Fizzadar/pyinfra/commit/62a8f081279779c4f1eed246139f615cf5fed642.patch";
      hash = "sha256-aT9SeSqXOD76LFzf6R/MWTtavcW6fZT7chkVg9aXiBg=";
    })
  ];

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
