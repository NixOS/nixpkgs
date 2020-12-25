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
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "66cf1517dd817bf6db3792608920274f964dd0ced8dabecd925b8bc17aa95740";
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
