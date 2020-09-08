{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, nose, numpy
, bottle, pyyaml, redis, six
, zlib
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "Jug";
  version = "2.0.2";
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
    sha256 = "859a4b4cb26a0010299b189c92cfba626852c97a38e22f3d1b56e4e1d8ad8620";
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
