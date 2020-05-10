{stdenv, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.5.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lry042qsamdzyw6zpmdld0v14g6cl05jsr9qdb7h5wnahf80mq1";
  };

  # requires root priviledges
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Netlink library";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = [maintainers.mic92];
    platforms = platforms.unix;
  };
}
