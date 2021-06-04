{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aiohttp
}:

buildPythonPackage rec {
  pname = "garages-amsterdam";
  version = "2.1.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "garages_amsterdam";
    rev = version;
    sha256 = "1lg66g0im6v0m294j82229n2b7bhs6kkrp0d9nh87k2rz7zgllil";
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
