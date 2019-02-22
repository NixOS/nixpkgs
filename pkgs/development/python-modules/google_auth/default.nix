{ stdenv, buildPythonPackage, fetchPypi
, pytest, mock, oauth2client, flask, requests, urllib3, pytest-localserver, six, pyasn1-modules, cachetools, rsa }:

buildPythonPackage rec {
  pname = "google-auth";
  version = "1.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8d64e9bc8cb6f0fc5360c693f86dc9ee6964081ee702e3b5ddc937f99efc950";
  };

  checkInputs = [ pytest mock oauth2client flask requests urllib3 pytest-localserver ];
  propagatedBuildInputs = [ six pyasn1-modules cachetools rsa ];

  # The removed test tests the working together of google_auth and google's https://pypi.python.org/pypi/oauth2client
  # but the latter is deprecated. Since it is not currently part of the nixpkgs collection and deprecated it will
  # probably never be. We just remove the test to make the tests work again.
  postPatch = ''rm tests/test__oauth2client.py'';

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "This library simplifies using Google’s various server-to-server authentication mechanisms to access Google APIs.";
    homepage = "https://google-auth.readthedocs.io/en/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
