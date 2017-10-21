{stdenv, buildPythonPackage, fetchurl}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.4.21";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pyroute2/${name}.tar.gz";
    sha256 = "7afad28ee0a0f3e7c34adaa9f953d00560ed9910203e93f107833b6e8d151171";
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
