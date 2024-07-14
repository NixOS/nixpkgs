{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "python-status";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TpyCR1TjZppKZWX9TD1sDdQTDnecVBrRaOcREOvOPlM=";
  };

  # Project doesn't ship tests yet
  doCheck = false;

  pythonImportsCheck = [ "status" ];

  meta = with lib; {
    description = "HTTP Status for Humans";
    homepage = "https://github.com/avinassh/status/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
