{ lib
, buildPythonPackage
, fetchPypi
, requests
, gevent
}:

buildPythonPackage rec {
  pname = "grequests";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XDPxQmjfW4+hEH2FN4Fb5v67rW7FYFJNakBLd3jPa6Y=";
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
