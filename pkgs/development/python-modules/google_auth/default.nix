{ stdenv, buildPythonPackage, fetchpatch, fetchPypi
, pytest, mock, oauth2client, flask, requests, urllib3, pytest-localserver, six, pyasn1-modules, cachetools, rsa }:

buildPythonPackage rec {
  pname = "google-auth";
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f7c6a64927d34c1a474da92cfc59e552a5d3b940d3266606c6a28b72888b9e4";
  };
  patches = [
    (fetchpatch {
      name = "use-new-pytest-api-to-keep-building-with-pytest5.patch";
      url = "https://github.com/googleapis/google-auth-library-python/commit/b482417a04dbbc207fcd6baa7a67e16b1a9ffc77.patch";
      sha256 = "07jpa7pa6sffbcwlsg5fgcv2vvngil5qpmv6fhjqp7fnvx0674s0";
    })
  ];

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
