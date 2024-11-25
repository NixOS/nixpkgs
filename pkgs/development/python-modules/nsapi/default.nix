{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  pythonOlder,
  pytz,
}:

buildPythonPackage rec {
  pname = "nsapi";
  version = "3.1.2";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aquatix";
    repo = "ns-api";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-H8qxqzcGZ52W/HbTuKdnfnaYdZFaxzuUhrniS1zsL2w=";
  };

  propagatedBuildInputs = [
    future
    pytz
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ns_api" ];

  meta = with lib; {
    description = "Python module to query routes of the Dutch railways";
    homepage = "https://github.com/aquatix/ns-api/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
