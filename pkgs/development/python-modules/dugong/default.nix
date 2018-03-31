{ stdenv, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "dugong";
  version = "3.5";

  disabled = pythonOlder "3.3"; # Library does not support versions older than 3.3

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y0rdxbiwm03zv6vpvapqilrird3h8ijz7xmb0j7ds5j4p6q3g24";
  };
}
