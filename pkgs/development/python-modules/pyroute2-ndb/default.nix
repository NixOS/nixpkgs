{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-ndb";
  version = "0.6.4";

  src = fetchPypi {
    pname = "pyroute2.ndb";
    inherit version;
    sha256 = "0q3py2n6w7nhdxi4l6vx8xpxh5if6hav4lcl5nwk8c4pgcrfd4vn";
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
