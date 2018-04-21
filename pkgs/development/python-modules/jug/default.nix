{ stdenv, buildPythonPackage, fetchPypi
, nose, numpy
, bottle, pyyaml, redis, six
, zlib }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Jug";
  version = "1.6.6";
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
    sha256 = "897ffbbbe8061772c238b4f436512ea3696016a04473c45a716d78c0de103ec1";
  };

  meta = with stdenv.lib; {
    description = "A Task-Based Parallelization Framework";
    license = licenses.mit;
    homepage = https://jug.readthedocs.io/;
    maintainers = with maintainers; [ luispedro ];
  };
}
