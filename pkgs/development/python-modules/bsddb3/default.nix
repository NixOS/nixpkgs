{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, python
}:

buildPythonPackage rec {
  pname = "bsddb3";
  version = "6.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42d621f4037425afcb16b67d5600c4556271a071a9a7f7f2c2b1ba65bc582d05";
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

  meta = with stdenv.lib; {
    description = "Python bindings for Oracle Berkeley DB";
    homepage = https://www.jcea.es/programacion/pybsddb.htm;
    license = with licenses; [ agpl3 ]; # License changed from bsd3 to agpl3 since 6.x
    maintainers = [ maintainers.costrouc ];
  };

}
