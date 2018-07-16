{stdenv, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42bf74495d95a0196a74dd171357f660175aba2bfc23f9b5f63e3830ccbef9ac";
  };

  # requires root priviledges
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Netlink library";
    homepage = https://github.com/svinota/pyroute2;
    license = licenses.asl20;
    maintainers = [maintainers.mic92];
    platforms = platforms.linux;
  };
}
