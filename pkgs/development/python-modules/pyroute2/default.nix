{stdenv, buildPythonPackage, fetchurl}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.4.13";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pyroute2/${name}.tar.gz";
    sha256 = "0f8a1ihxc1r78m6dqwhks2vdp4vwwbw72mbv88v70qmkb0pxgwwk";
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
