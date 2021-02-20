{ lib, fetchPypi, buildPythonPackage
, attrs, boto3, requests, gradient_statsd, terminaltables
, click-completion , click-didyoumean, click-help-colors
, colorama, requests_toolbelt, gradient-utils, halo, progressbar2
, marshmallow, pyyaml, websocket_client
}:

buildPythonPackage rec {
  pname = "gradient";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ed10db306d4c8632b7d04d71d44a04331a6e80e5ebab7296a98e67e8a50fb71";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'attrs<=' 'attrs>=' \
      --replace 'colorama==' 'colorama>=' \
      --replace 'PyYAML==' 'PyYAML>=' \
      --replace 'marshmallow<' 'marshmallow>='
  '';

  propagatedBuildInputs = [ attrs boto3 requests gradient_statsd terminaltables
    click-completion click-didyoumean click-help-colors requests_toolbelt
    colorama gradient-utils halo marshmallow progressbar2 pyyaml websocket_client
  ];

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  meta = with lib; {
    description = "The command line interface for Gradient";
    homepage    = "https://github.com/Paperspace/gradient-cli";
    license     = licenses.isc;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
