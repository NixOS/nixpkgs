{ lib
, buildPythonPackage
, fetchPypi
, requests
, gevent
}:

buildPythonPackage rec {
  pname = "grequests";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rpnim3ppxjdsaa869h1jdimcyc66mamcs593rd7brk8cq68kv3x";
  };

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = [ requests gevent ];

  meta = with lib; {
    description = "Asynchronous HTTP requests";
    homepage = "https://github.com/kennethreitz/grequests";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ matejc ];
  };

}
