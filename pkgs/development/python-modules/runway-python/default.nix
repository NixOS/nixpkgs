{ lib
, buildPythonPackage
, fetchPypi
, flask
, flask-compress
, flask-cors
, flask-sockets
, numpy
, scipy
, pillow
, gevent
, wget
, six
, colorcet
, unidecode
, urllib3
}:

buildPythonPackage rec {
  pname = "runway-python";
  version = "0.5.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d75c44008275213034977c75bc2dc6f419e7f11d087984e3faea1e0cf6da69d";
  };

  propagatedBuildInputs = [ flask flask-compress flask-cors flask-sockets numpy scipy pillow gevent wget six colorcet unidecode urllib3 ];

  # tests are not packaged in the released tarball
  doCheck = false;

  pythonImportsCheck = [
    "runway"
  ];

  meta = {
    description = "Helper library for creating Runway models";
    homepage = https://github.com/runwayml/model-sdk;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
