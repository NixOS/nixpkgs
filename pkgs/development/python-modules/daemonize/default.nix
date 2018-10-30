{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "daemonize";
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y139sq657bpzfv6k0aqm4071z4s40i6ybpni9qvngvdcz6r86n2";
  };

  meta = with stdenv.lib; {
    description = "Library to enable your code run as a daemon process on Unix-like systems";
    homepage = https://github.com/thesharp/daemonize;
    license = licenses.mit;
  };

}
