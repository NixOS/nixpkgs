{ stdenv
, buildPythonPackage
, fetchPypi
, tornado
, requests
, httplib2
, sure
, nose
, coverage
, certifi
, urllib3
, rednose
, nose-randomly
}:

buildPythonPackage rec {
  pname = "httpretty";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01b52d45077e702eda491f4fe75328d3468fd886aed5dcc530003e7b2b5939dc";
  };

  checkInputs = [ tornado requests httplib2 sure nose nose-randomly rednose coverage certifi ];
  propagatedBuildInputs = [ urllib3 ];

  meta = with stdenv.lib; {
    homepage = "https://falcao.it/HTTPretty/";
    description = "HTTP client request mocking tool";
    license = licenses.mit;
  };

}
