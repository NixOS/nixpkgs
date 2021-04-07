{ lib
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
, six
, pyopenssl
}:

buildPythonPackage rec {
  pname = "google-auth";
  version = "1.28.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-m9Q20ZqwRwAaE0ByDStinrlt1QMljFJJIewq8+6IqA4=";
  };

  propagatedBuildInputs = [
    cachetools
    pyasn1-modules
    rsa
    six
    pyopenssl
  ];

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

  meta = with lib; {
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
