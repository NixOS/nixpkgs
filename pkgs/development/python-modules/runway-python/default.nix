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
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30046ced74b5502eca604b1ae766fd3daa1b5ed6379fbe1210730710c752d4f6";
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
