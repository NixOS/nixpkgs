{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, nose, numpy
, bottle, pyyaml, redis, six
, zlib }:

buildPythonPackage rec {
  pname = "Jug";
  version = "2.0.0";
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
    sha256 = "1am73pis8qrbgmpwrkja2qr0n9an6qha1k1yp87nx6iq28w5h7cv";
  };

  meta = with stdenv.lib; {
    description = "A Task-Based Parallelization Framework";
    license = licenses.mit;
    homepage = "https://jug.readthedocs.io/";
    maintainers = with maintainers; [ luispedro ];
  };
}
