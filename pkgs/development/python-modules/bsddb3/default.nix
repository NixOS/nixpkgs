{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, python
}:

buildPythonPackage rec {
  pname = "bsddb3";
  version = "6.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17yw0by4lycwpvnx06cnzbbchz4zvzbx3j89b20xa314xdizmxxh";
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
