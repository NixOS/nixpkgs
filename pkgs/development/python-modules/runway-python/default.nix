{ lib
, buildPythonPackage
, fetchPypi
, flask
, flask-cors
, numpy
, pillow
, gevent
, wget
, six
, colorcet
}:

buildPythonPackage rec {
  pname = "runway-python";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3573a003899eb33c0edbc1d59c16c8c19c092512da0c75ceb1f46063a18c7e9";
  };

  propagatedBuildInputs = [ flask flask-cors numpy pillow gevent wget six colorcet ];

  # tests are not packaged in the released tarball
  doCheck = false;

  meta = {
    description = "Helper library for creating Runway models";
    homepage = https://github.com/runwayml/model-sdk;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
