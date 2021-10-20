{ lib, buildPythonPackage, fetchPypi, isPy27, aspell, aspellDicts, python }:

buildPythonPackage rec {
  pname = "aspell-python";
  version = "1.15";
  disabled = isPy27;

  src = fetchPypi {
    inherit version;
    pname = "aspell-python-py3";
    extension = "tar.bz2";
    sha256 = "13dk3jrvqmfvf2w9b8afj37d8bh32kcx295lyn3z7r8qch792hi0";
  };

  buildInputs = [ aspell ];

  checkPhase = ''
    export ASPELL_CONF="dict-dir ${aspellDicts.en}/lib/aspell"
    export HOME=$(mktemp -d)
    ${python.interpreter} test/unittests.py
  '';

  pythonImportsCheck = [ "aspell" ];

  meta = with lib; {
    description = "Python wrapper for aspell (C extension and python version)";
    homepage = "https://github.com/WojciechMula/aspell-python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
