{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "advantage-air";
  version = "0.4.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "advantage_air";
    inherit version;
    hash = "sha256-4rRR9IxzH5EiYfWzWYeyCwoLB2LetBVyH7L3nkvp+gA=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "advantage_air" ];

  meta = {
    description = "API helper for Advantage Air's MyAir and e-zone API";
    homepage = "https://github.com/Bre77/advantage_air";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
