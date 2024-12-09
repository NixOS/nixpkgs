{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools-scm,
  aiohttp,
  pytz,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "pygti";
  version = "0.9.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vigonotion";
    repo = "pygti";
    rev = "refs/tags/v${version}";
    hash = "sha256-2T4Yw4XEOkv+IWyB4Xa2dPu929VH0tLeUjQ5S8EVXz0=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    aiohttp
    pytz
    voluptuous
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pygti.auth"
    "pygti.exceptions"
    "pygti.gti"
  ];

  meta = with lib; {
    description = "Access public transport information in Hamburg, Germany";
    homepage = "https://github.com/vigonotion/pygti";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
