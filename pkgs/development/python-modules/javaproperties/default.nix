{ lib, buildPythonPackage, fetchFromGitHub
, six
, pytest
, python-dateutil
}:

buildPythonPackage rec {
  version = "0.8.1";
  pname = "javaproperties";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    sha256 = "16rcdw5gd4a21v2xb1j166lc9z2dqcv68gqvk5mvpnm0x6nwadgp";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ python-dateutil pytest ];
  checkPhase = ''
    rm tox.ini
    pytest -k 'not dumps and not time' --ignore=test/test_propclass.py
  '';

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
