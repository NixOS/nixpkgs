{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, nose, numpy
, bottle, pyyaml, redis, six
, zlib
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "Jug";
  version = "2.0.3";
  buildInputs = [ nose numpy ];
  propagatedBuildInputs = [
    bottle
    pyyaml
    redis
    six

    zlib
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "3656355c1f9cd1731065c9d589f66d33653cbe5e0879cbe5d8447b51e4ddb4ec";
  };

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "jug" ];

  meta = with stdenv.lib; {
    description = "A Task-Based Parallelization Framework";
    license = licenses.mit;
    homepage = "https://jug.readthedocs.io/";
    maintainers = with maintainers; [ luispedro ];
  };
}
