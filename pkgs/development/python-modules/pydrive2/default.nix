{ lib
, buildPythonPackage
, fetchPypi
, google-api-python-client
, oauth2client
, pyopenssl
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "pydrive2";
  version = "1.15.0";

  src = fetchPypi {
    pname = "PyDrive2";
    inherit version;
    sha256 = "sha256-OuBrZr+WP0NSSYnIf01ngDlEH+BZmTxnA/szzDxtiuw=";
  };

  propagatedBuildInputs = [
    google-api-python-client
    oauth2client
    pyopenssl
    pyyaml
    six
  ];

  doCheck = false;

  pythonImportsCheck = [ "pydrive2" ];

  meta = {
    description = "Google Drive API Python wrapper library. Maintained fork of PyDrive.";
    homepage = "https://github.com/iterative/PyDrive2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sei40kr ];
  };
}
