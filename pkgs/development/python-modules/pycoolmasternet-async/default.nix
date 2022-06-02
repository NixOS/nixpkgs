{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pycoolmasternet-async";
  version = "0.1.3";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pycoolmasternet-async";
    rev = "v${version}";
    hash = "sha256-1Xd8OdN8d3g23kQZqihZrNLKoqLCbu5BvAMNitg8aDA=";
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
