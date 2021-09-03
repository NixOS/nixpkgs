{ lib, buildPythonPackage, fetchPypi, fetchpatch
, nose, numpy
, bottle, pyyaml, redis, six
, zlib
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "Jug";
  version = "2.1.1";
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
    sha256 = "8ae7bb45d4495cf3d0dc5dd9df104a35bba2ca83eb4576732cadf8469e7cf1a1";
  };

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "jug" ];

  meta = with lib; {
    description = "A Task-Based Parallelization Framework";
    license = licenses.mit;
    homepage = "https://jug.readthedocs.io/";
    maintainers = with maintainers; [ luispedro ];
  };
}
