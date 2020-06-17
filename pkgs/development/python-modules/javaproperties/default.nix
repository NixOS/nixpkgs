{ lib, buildPythonPackage, fetchFromGitHub
, six
, pytest
, dateutil
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "javaproperties";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    sha256 = "14dlzwr4gxlbgjy012i4pqs2rn2rmp21w8n1k1wwjkf26mcvrq5s";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ dateutil pytest ];
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
