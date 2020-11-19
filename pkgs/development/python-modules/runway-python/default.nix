{ lib
, buildPythonPackage
, fetchPypi
, flask
, flask-compress
, flask-cors
, flask-sockets
, imageio
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
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "695d78f8edeb6a7ca98d8351adb36948d56cceeffe8a84896c9fbfd349fc4cb8";
  };

  propagatedBuildInputs = [
    colorcet
    flask
    flask-compress
    flask-cors
    flask-sockets
    gevent
    imageio
    numpy
    pillow
    scipy
    six
    unidecode
    urllib3
    wget
  ];

  # tests are not packaged in the released tarball
  doCheck = false;

  pythonImportsCheck = [
    "runway"
  ];

  meta = {
    description = "Helper library for creating Runway models";
    homepage = "https://github.com/runwayml/model-sdk";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
