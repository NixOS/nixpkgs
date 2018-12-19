{ pkgs
, buildPythonPackage
, fetchPypi
, python
, certifi
, requests_oauthlib
, typing
, isodate
}:

buildPythonPackage rec {
  version = "0.6.2";
  pname = "msrest";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0icklfjaagk0j9iwq897avmqhwwmgs7c5yy5jw3ppdqz6h0sm38v";
  };

  propagatedBuildInputs = [ certifi requests_oauthlib typing isodate ];

  meta = with pkgs.lib; {
    description = "The runtime library 'msrest' for AutoRest generated Python clients.";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.mit;
    maintainers = with maintainers; [ bendlas ];
  };
}
