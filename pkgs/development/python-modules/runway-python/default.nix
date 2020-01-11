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
  version = "0.5.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06e0138cc4cf2ddb7304502f5c7b53269ce73679c5784c8d6b423db04d179c18";
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
