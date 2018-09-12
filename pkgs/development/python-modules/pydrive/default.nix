{ stdenv, buildPythonPackage, fetchPypi, oauth2client, pyyaml, google_api_python_client }:

buildPythonPackage rec {
  pname = "PyDrive";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83890dcc2278081c6e3f6a8da1f8083e25de0bcc8eb7c91374908c5549a20787";
  };

  propagatedBuildInputs = [ oauth2client pyyaml google_api_python_client ];

  # does not work due missing secrets file
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/googledrive/PyDrive;
    description = "PyDrive is a wrapper library of google-api-python-client that simplifies many common Google Drive API tasks";
    license = licenses.asl20;
    maintainers = with maintainers; [ poelzi ];
  };
}
