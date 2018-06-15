{stdenv, buildPythonPackage, fetchurl}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.5.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pyroute2/${name}.tar.gz";
    sha256 = "e69dc81dc3f10ccb33186ddcce910e116b4e77304e93af4092567130bcd6df5c";
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
