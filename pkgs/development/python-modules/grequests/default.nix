{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, gevent
}:

buildPythonPackage rec {
  pname = "grequests";
  version = "0.6.0";

  src = fetchFromGitHub {
     owner = "kennethreitz";
     repo = "grequests";
     rev = "v0.6.0";
     sha256 = "1vc9qj1fjyaisbfcqhzzkll0g1fj3lwk941bvnnq03lj5z63wdcz";
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
