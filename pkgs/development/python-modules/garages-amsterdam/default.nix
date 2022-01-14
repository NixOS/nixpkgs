{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aiohttp
}:

buildPythonPackage rec {
  pname = "garages-amsterdam";
  version = "3.2.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "garages_amsterdam";
    rev = version;
    sha256 = "16f2742r9p3mrg2nz8lnkgsxabbjga2qnp9vzq59026q6mmfwkm9";
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
