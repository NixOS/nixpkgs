{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-ndb";
  version = "0.6.1";

  src = fetchPypi {
    pname = "pyroute2.ndb";
    inherit version;
    sha256 = "0lzvh0vva8i86h00add0b45s4f5dn6zbgysfvmzrxxasvda7fhlj";
  };

  propagatedBuildInputs = [
    pyroute2-core
  ];

  # pyroute2 sub-modules have no tests
  doCheck = false;

  pythonImportsCheck = [ "pr2modules.ndb" ];

  meta = with lib; {
    description = "NDB module for pyroute2";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
