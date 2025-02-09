{ lib
, buildPythonPackage
, fetchPypi
, expiringdict
, google-auth-httplib2
, google-auth-oauthlib
, google-api-python-client
}:

buildPythonPackage rec {
  pname = "drivelib";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bz3dn6wm9mlm2w8czwjmhvf3ws3iggr57hvd8z8acl1qafr2g4m";
  };

  propagatedBuildInputs = [
    google-api-python-client
    google-auth-oauthlib
    google-auth-httplib2
    expiringdict
  ];

  # tests depend on a google auth token
  doCheck = false;

  pythonImportsCheck = [ "drivelib" ];

  meta = with lib; {
    description = "Easy access to the most common Google Drive API calls";
    homepage = "https://pypi.org/project/drivelib/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gravndal ];
  };
}
