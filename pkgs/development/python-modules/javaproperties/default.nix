{ lib, buildPythonPackage, fetchFromGitHub
, six
, pytest
, dateutil
}:

buildPythonPackage rec {
  version = "0.5.2";
  pname = "javaproperties";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    sha256 = "14hrp94cjj44yldf3k71wbq88cmlf01dfadi53gcirnsa56ddz5d";
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
