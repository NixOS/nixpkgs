{stdenv, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "pyroute2";
  version = "0.5.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wjamijkg2pp9mgj5k4qw3jl2i3ajikkps0zp5c52wcxm3qmks85";
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
