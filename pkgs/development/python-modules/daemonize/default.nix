{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "daemonize";
  version = "2.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0194e861826be456c7c69985825ac7b79632d8ac7ad4cde8e12fee7971468c8";
  };

  meta = with stdenv.lib; {
    description = "Library to enable your code run as a daemon process on Unix-like systems";
    homepage = https://github.com/thesharp/daemonize;
    license = licenses.mit;
  };

}
