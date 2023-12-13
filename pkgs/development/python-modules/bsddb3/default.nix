{ lib
, buildPythonPackage
, fetchPypi
, pkgs
, python
}:

buildPythonPackage rec {
  pname = "bsddb3";
  version = "6.2.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70d05ec8dc568f42e70fc919a442e0daadc2a905a1cfb7ca77f549d49d6e7801";
  };

  buildInputs = [ pkgs.db ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  # Path to database need to be set.
  # Somehow the setup.py flag is not propagated.
  #setupPyBuildFlags = [ "--berkeley-db=${pkgs.db}" ];
  # We can also use a variable
  preConfigure = ''
    export BERKELEYDB_DIR=${pkgs.db.dev};
  '';

  meta = with lib; {
    description = "Python bindings for Oracle Berkeley DB";
    homepage = "https://www.jcea.es/programacion/pybsddb.htm";
    license = with licenses; [ agpl3 ]; # License changed from bsd3 to agpl3 since 6.x
    maintainers = [ ];
  };

}
