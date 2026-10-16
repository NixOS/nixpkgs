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

  meta = {
    description = "HTTP Status for Humans";
    homepage = "https://github.com/avinassh/status/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
