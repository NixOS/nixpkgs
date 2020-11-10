{ stdenv, buildPythonPackage, fetchpatch, fetchPypi, pythonOlder
, pytestCheckHook, cachetools, flask, freezegun, mock, oauth2client
, pyasn1-modules, pytest, pytest-localserver, requests, responses, rsa
, setuptools, six, urllib3 }:

buildPythonPackage rec {
  pname = "google-auth";
  version = "1.22.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fs448jcx2cbpk0nq3picndfryjsakmd9allggvh7mrqjiw723ww";
  };

  disabled = pythonOlder "3.5";

  propagatedBuildInputs = [ six pyasn1-modules cachetools rsa setuptools ];

  checkInputs = [
    flask
    freezegun
    mock
    oauth2client
    pytestCheckHook
    pytest-localserver
    requests
    responses
    urllib3
  ];

  meta = with stdenv.lib; {
    description = "Google Auth Python Library";
    longDescription = ''
      This library simplifies using Google’s various server-to-server
      authentication mechanisms to access Google APIs.
    '';
    homepage = "https://github.com/googleapis/google-auth-library-python";
    changelog =
      "https://github.com/googleapis/google-auth-library-python/blob/v${version}/CHANGELOG.md";
    # Documentation: https://googleapis.dev/python/google-auth/latest/index.html
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
