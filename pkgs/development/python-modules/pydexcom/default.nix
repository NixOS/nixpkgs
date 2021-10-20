{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "pydexcom";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "gagebenne";
    repo = pname;
    rev = version;
    sha256 = "19h7r0qbsqd6k6g4nz6z3k9kdmk0sx5zpsrgxwnhsff5fqi0y2ls";
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
