{stdenv, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.5.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0akls1w67v17dmgr07n6rr5xy6yyj6p83ss05033gk1c3mfsbb1r";
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
