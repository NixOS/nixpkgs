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
    sha256 = "1434cahnad46ry2pyj8mk2brc8dbjv2yjcpfcxz5rihfwqawrv4a";
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
