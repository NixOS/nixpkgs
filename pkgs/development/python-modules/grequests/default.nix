{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, gevent
}:

buildPythonPackage rec {
  pname = "grequests";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8aeccc15e60ec65c7e67ee32e9c596ab2196979815497f85cf863465a1626490";
  };

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = [ requests gevent ];

  meta = with stdenv.lib; {
    description = "Asynchronous HTTP requests";
    homepage = https://github.com/kennethreitz/grequests;
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ matejc ];
  };

}
