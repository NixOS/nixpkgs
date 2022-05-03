{ lib, buildPythonPackage, fetchPypi, nose, numpy
, bottle, pyyaml, redis, six
, zlib
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "Jug";
  version = "2.2.0";
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
    sha256 = "sha256-2Y9xRr5DyV9UqG6tiq9rYET2Z7LaPXfzwYKKGwR3OSs=";
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
