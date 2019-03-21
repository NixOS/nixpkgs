{stdenv, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w6z4j8l9898bj214v2mh7vx2g43j1b70ijjvc7q3316fscal469";
  };

  # requires root priviledges
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Netlink library";
    homepage = https://github.com/svinota/pyroute2;
    license = licenses.asl20;
    maintainers = [maintainers.mic92];
    platforms = platforms.unix;
  };
}
