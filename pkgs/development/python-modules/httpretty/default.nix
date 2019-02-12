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
, six
, mock
}:

buildPythonPackage rec {
  pname = "httpretty";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01b52d45077e702eda491f4fe75328d3468fd886aed5dcc530003e7b2b5939dc";
  };

  checkInputs = [ nose sure coverage mock rednose
  # Following not declared in setup.py
    nose-randomly requests tornado httplib2
  ];
  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    homepage = "https://falcao.it/HTTPretty/";
    description = "HTTP client request mocking tool";
    license = licenses.mit;
  };

}
