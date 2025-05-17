{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "fullmoon";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WVz0na1v83dRpV2bZZnR7L4gDm2KwRP66h6xH24Xv4Y=";
  };

  build-system = [ setuptools ];

  meta = {
    description = "Determine the occurrence of the next full moon or to determine if a given date is/was/will be a full moon";
    homepage = "https://github.com/jr-k/python-fullmoon";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
}
