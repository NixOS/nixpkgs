{stdenv, buildPythonPackage, fetchurl}:

buildPythonPackage rec {
  name = "pyroute2-0.4.12";

  src = fetchurl {
    url = "mirror://pypi/p/pyroute2/${name}.tar.gz";
    sha256 = "0csp6y38pgswhn46rivdgrlqw99dpjzwa0g32h6iiaj12n2f9qlq";
  };

  # requires root priviledges
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python Netlink library";
    homepage = https://github.com/svinota/pyroute2;
    license = licenses.asl20;
    maintainers = [maintainers.mic92];
    platform = platforms.linux;
  };
}
