{ stdenv
, lib
, buildPythonPackage
, pythonAtLeast
, fetchFromGitHub
, net-snmp
, openssl
, pytest
, pytestcov
, pytest-flake8
, pytest-sugar
, termcolor
}:

buildPythonPackage rec {
  pname = "easysnmp";
  version = "0.2.5";

  # See https://github.com/kamakazikamikaze/easysnmp/issues/108
  disabled = pythonAtLeast "3.7";

  src = fetchFromGitHub {
    owner = "kamakazikamikaze";
    repo = pname;
    rev = version;
    sha256 = "1si9iyxqj6z22jzn6m93lwpinsqn20lix2py3jm3g3fmwawkd735";
  };

  checkInputs = [
    pytest
    pytestcov
    pytest-flake8
    pytest-sugar
    termcolor
  ];

  buildInputs = [
    net-snmp
    openssl
  ];

  buildPhase = ''
    python setup.py build bdist_wheel --basedir=${lib.getBin net-snmp}/bin
  '';

  # Unable to get tests to pass, even running by hand. The pytest tests have
  # become stale.
  doCheck = false;

  meta = with lib; {
    description = "A blazingly fast and Pythonic SNMP library based on the official Net-SNMP bindings";
    homepage = https://easysnmp.readthedocs.io/en/latest/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ WhittlesJr ];
  };
}
