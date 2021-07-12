{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "locket";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e1faba403619fe201552f083f1ecbf23f550941bc51985ac6ed4d02d25056dd";
  };

  buildInputs = [ pytest ];

  # weird test requirements (spur.local>=0.3.7,<0.4)
  doCheck = false;

  meta = with lib; {
    description = "Locket implements a lock that can be used by multiple processes provided they use the same path.";
    homepage = "https://github.com/mwilliamson/locket.py";
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
