{ stdenv, buildPythonPackage, fetchPypi
, nose, numpy
, bottle, pyyaml, redis, six
, zlib }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Jug";
  version = "1.6.5";
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
    sha256 = "982e18c4b837dd7828e718bb252b4ba78da3e2dfe65d1d92b85e03e9c9e0146a";
  };

  meta = with stdenv.lib; {
    description = "A Task-Based Parallelization Framework";
    license = licenses.mit;
    homepage = https://jug.readthedocs.io/;
    maintainers = with maintainers; [ luispedro ];
  };
}
