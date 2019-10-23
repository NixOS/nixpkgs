{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, nose, numpy
, bottle, pyyaml, redis, six
, zlib }:

buildPythonPackage rec {
  pname = "Jug";
  version = "1.6.9";
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
    sha256 = "0193hp8ap6caw57jdch3vw0hl5m8942lxhjdsfaxk4bfb239l5kz";
  };

  meta = with stdenv.lib; {
    description = "A Task-Based Parallelization Framework";
    license = licenses.mit;
    homepage = https://jug.readthedocs.io/;
    maintainers = with maintainers; [ luispedro ];
  };
}
