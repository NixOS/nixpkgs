{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pbkdf2";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rGOXNp8SghLEMGSitIeAONq3jatBh1NkVUqvKmhOaXk=";
  };

  # ImportError: No module named test
  doCheck = false;

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar ];
  };
}
