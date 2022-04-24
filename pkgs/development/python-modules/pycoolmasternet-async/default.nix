{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pycoolmasternet-async";
  version = "0.1.2";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pycoolmasternet-async";
    rev = "v${version}";
    sha256 = "0qzdk18iqrvin8p8zrydf69d6pii3j47j11h7ymmsx08gh7c176g";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pycoolmasternet_async" ];

  meta = with lib; {
    description = "Python library to control CoolMasterNet HVAC bridges over asyncio";
    homepage = "https://github.com/OnFreund/pycoolmasternet-async";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
