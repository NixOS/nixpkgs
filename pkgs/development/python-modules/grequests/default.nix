{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, gevent
}:

buildPythonPackage rec {
  pname = "grequests";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lafzax5igbh8y4x0krizr573wjsxz7bhvwygiah6qwrzv83kv5c";
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
