{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "pydexcom";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "gagebenne";
    repo = pname;
    rev = version;
    sha256 = "sha256-fC8K2NHCFcqzmsH02XPAGZtUTTXWyr0p4524UVv6yU4=";
  };

  propagatedBuildInputs = [ requests ];

  # tests are interacting with the Dexcom API
  doCheck = false;
  pythonImportsCheck = [ "pydexcom" ];

  meta = with lib; {
    description = "Python API to interact with Dexcom Share service";
    homepage = "https://github.com/gagebenne/pydexcom";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
