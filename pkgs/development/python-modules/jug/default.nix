{ stdenv, buildPythonPackage, fetchPypi
, nose, numpy
, bottle, pyyaml, redis, six
, zlib }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Jug";
  version = "1.6.3";
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
    sha256 = "0dpcwjaf8zzqpdz8w8h0p7vmd6z6bzfz2805a6bdjqs9hhkhrg86";
  };

  meta = with stdenv.lib; {
    description = "A Task-Based Parallelization Framework";
    license = licenses.mit;
    url = https://jug.readthedocs.io/;
    maintainers = with maintainers; [ luispedro ];
  };
}
