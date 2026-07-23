{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  stevedore,
  prettytable,
  pyserial,
  flask,
}:

buildPythonPackage rec {
  pname = "concord232";
  version = "0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JasonCarter80";
    repo = "concord232";
    tag = "v${version}";
    hash = "sha256-qMHFOKuNuk4Z/FDNRqh1nsnA5vCW+9YXGK6d7Td5O5s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    stevedore
    prettytable
    pyserial
    flask
  ];

  # Package has no tests
  doCheck = false;

  meta = {
    description = "GE Concord 4 RS232 Serial Interface Library and Server";
    homepage = "https://github.com/JasonCarter80/concord232";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
