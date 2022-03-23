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
  version = "1.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-r+7ka3WKE6uHP//p1N71hgTGit7Eo3x9INpbKPYbFMI=";
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
