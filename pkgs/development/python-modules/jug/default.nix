{ stdenv, buildPythonPackage, fetchPypi
, nose, numpy
, bottle, pyyaml, redis, six
, zlib }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Jug";
  version = "1.6.4";
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
    sha256 = "e739b20e7fe53ac50f5954b9e32568bdd92012dd4bd199d13e2a675ccd69d97d";
  };

  meta = with stdenv.lib; {
    description = "A Task-Based Parallelization Framework";
    license = licenses.mit;
    url = https://jug.readthedocs.io/;
    maintainers = with maintainers; [ luispedro ];
  };
}
