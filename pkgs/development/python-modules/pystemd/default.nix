{ stdenv, buildPythonPackage, fetchPypi, mock, pytest, six, systemd }:

buildPythonPackage rec {
  pname = "pystemd";
  version = "0.5.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "000001hxv25vwcsvc0avg42v89c7qcjdpw6dr8419prmcb9186i5";
  };

  buildInputs = [ systemd ];
  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest mock ];
  checkPhase = "pytest tests";

  meta = with stdenv.lib; {
    description = "A thin Cython-based wrapper on top of libsystemd, focused on exposing the dbus API via sd-bus in an automated and easy to consume way.";
    homepage = https://github.com/facebookincubator/pystemd/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ flokli ];
  };
}
