{ stdenv, buildPythonPackage, fetchPypi
, nose, numpy
, bottle, pyyaml, redis, six
, zlib }:

buildPythonPackage rec {
  pname = "Jug";
  version = "1.6.7";
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
    sha256 = "a7faba838f3437163ae8459bff96e2c6ca1298312bdb9104c702685178d17269";
  };

  meta = with stdenv.lib; {
    description = "A Task-Based Parallelization Framework";
    license = licenses.mit;
    homepage = https://jug.readthedocs.io/;
    maintainers = with maintainers; [ luispedro ];
  };
}
