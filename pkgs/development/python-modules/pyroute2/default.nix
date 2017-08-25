{stdenv, buildPythonPackage, fetchurl}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.4.19";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pyroute2/${name}.tar.gz";
    sha256 = "122a1e34702287b805742a6edd8fe8483608238bd1602df2d5e3274bd8e8030a";
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
