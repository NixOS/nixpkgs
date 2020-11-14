{ stdenv, fetchPypi, buildPythonPackage, halo
, boto3, requests, gradient_statsd, terminaltables
, click-completion , click-didyoumean, click-help-colors
, colorama, requests_toolbelt, gradient-utils, progressbar2
, websocket_client, pyyaml, marshmallow2, attrs
}:

buildPythonPackage rec {
  pname = "gradient";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "zzsKTl4UZMFvJ+k4mgY3LmXSaupMTJsbzisXsT7ba9Q=";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "attrs<=19" "attrs" \
      --replace "colorama==0.4.3" "colorama"
  '';

  propagatedBuildInputs = [ boto3 requests gradient_statsd terminaltables
    click-completion click-didyoumean click-help-colors requests_toolbelt
    colorama gradient-utils progressbar2 halo websocket_client pyyaml
    marshmallow2 attrs
  ];

  # Tests are broken
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python API for Paperspace Cloud";
    homepage    = "https://paperspace.com";
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
