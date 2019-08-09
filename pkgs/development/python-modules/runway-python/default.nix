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
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef15c0df60cfe7ea26b070bbe2ba522d67d247b157c20f3f191fe545c17d0b85";
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
