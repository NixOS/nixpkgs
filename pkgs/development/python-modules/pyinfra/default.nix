{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, gevent
, click
, colorama
, configparser
, distro
, jinja2
, paramiko
, python-dateutil
, pywinrm
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "pyinfra";
  version = "2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lbX1KzWv2T2p7HlxSw9eBIWOO2QJ4rzTU1Tyyhwp5Yk=";
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
    setuptools
    six
  ];

  doCheck = false;

  pythonImportsCheck = [
    "pyinfra"
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
