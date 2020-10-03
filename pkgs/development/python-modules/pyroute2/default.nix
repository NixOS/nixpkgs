{stdenv, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.5.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "774c5ecf05fe40f0f601a7ab33c19ca0b24f00bf4a094e58deaa5333b7ca49b5";
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
