{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aiohttp
}:

buildPythonPackage rec {
  pname = "garages-amsterdam";
  version = "2.1.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "garages_amsterdam";
    rev = version;
    sha256 = "1m0bc3bzb83apprk412s7k5r2g6p5br2hrak2a976lh9ifk1d8hj";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # The only test requires network access
  doCheck = false;

  pythonImportsCheck = [ "garages_amsterdam" ];

  meta = with lib; {
    description = "Python client for getting garage occupancy in Amsterdam";
    homepage = "https://github.com/klaasnicolaas/garages_amsterdam";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
