{ lib
, buildPythonPackage
, fetchPypi
, requests
, gevent
}:

buildPythonPackage rec {
  pname = "grequests";
<<<<<<< HEAD
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XDPxQmjfW4+hEH2FN4Fb5v67rW7FYFJNakBLd3jPa6Y=";
=======
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rpnim3ppxjdsaa869h1jdimcyc66mamcs593rd7brk8cq68kv3x";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
