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
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5293bca6589747db687c593b81f52dc9df8155367ffa57ddc1993a6f9d95bde";
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
