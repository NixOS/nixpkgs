{stdenv, buildPythonPackage, fetchurl}:

buildPythonPackage rec {
  name = "pyroute2-0.4.13";

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
    platform = platforms.linux;
  };
}
