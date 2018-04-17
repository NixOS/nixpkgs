{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "locket";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d4z2zngrpqkrfhnd4yhysh66kjn4mblys2l06sh5dix2p0n7vhz";
  };

  buildInputs = [ pytest ];

  # weird test requirements (spur.local>=0.3.7,<0.4)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Locket implements a lock that can be used by multiple processes provided they use the same path.";
    homepage = https://github.com/mwilliamson/locket.py;
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
