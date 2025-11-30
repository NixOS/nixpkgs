{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  standard-telnetlib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynut2";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "python-nut2";
    rev = version;
    sha256 = "1lg7n1frndfgw73s0ssl1h7kc6zxm7fpiwlc6v6d60kxzaj1dphx";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    standard-telnetlib
  ];

  pythonImportsCheck = [ "pynut2.nut2" ];

  # tests are unmaintained and broken
  doCheck = false;

  meta = with lib; {
    description = "API overhaul of PyNUT, a Python library to allow communication with NUT (Network UPS Tools) servers";
    homepage = "https://github.com/mezz64/python-nut2";
    license = with licenses; [ gpl3Plus ];
    maintainers = [ maintainers.luker ];
  };
}
