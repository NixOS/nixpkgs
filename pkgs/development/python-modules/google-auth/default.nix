{ stdenv
, buildPythonPackage
, fetchpatch
, fetchPypi
, pytestCheckHook
, cachetools
, flask
, freezegun
, mock
, oauth2client
, pyasn1-modules
, pytest-localserver
, responses
, rsa
}:

buildPythonPackage rec {
  pname = "google-auth";
  version = "1.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bmdqkyv8k8n6s8dss4zpbcq1cdxwicpb42kwybd02ia85mh43hb";
  };

  propagatedBuildInputs = [ pyasn1-modules cachetools rsa ];

  checkInputs = [
    flask
    freezegun
    mock
    oauth2client
    pytestCheckHook
    pytest-localserver
    responses
  ];

  pythonImportsCheck = [
    "google.auth"
    "google.oauth2"
  ];

  meta = with stdenv.lib; {
    description = "Google Auth Python Library";
    longDescription = ''
      This library simplifies using Google’s various server-to-server
      authentication mechanisms to access Google APIs.
    '';
    homepage = "https://github.com/googleapis/google-auth-library-python";
    changelog = "https://github.com/googleapis/google-auth-library-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
