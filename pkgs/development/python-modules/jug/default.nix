{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, nose, numpy
, bottle, pyyaml, redis, six
, zlib }:

buildPythonPackage rec {
  pname = "Jug";
  version = "1.6.8";
  buildInputs = [ nose numpy ];
  propagatedBuildInputs = [
    bottle
    pyyaml
    redis
    six

    zlib
  ];

  patches = [
    # Fix numpy usage. Remove with the next release
    (fetchpatch {
      url = "https://github.com/luispedro/jug/commit/814405ce1553d3d2e2e96cfbeae05d63dc4f2491.patch";
      sha256 = "1l8sssp856dmhxbnv3pzxgwgpv6rb884l0in5x7q19czwn5a4vmv";
      excludes = [ "ChangeLog" ];
    })
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s1l1ln9s6mi2aa132gqr789nnhdpiw057j3sp54v1sbq2cwd42p";
  };

  meta = with stdenv.lib; {
    description = "A Task-Based Parallelization Framework";
    license = licenses.mit;
    homepage = https://jug.readthedocs.io/;
    maintainers = with maintainers; [ luispedro ];
  };
}
