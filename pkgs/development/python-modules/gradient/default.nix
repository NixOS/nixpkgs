{ lib, fetchPypi, buildPythonPackage
, attrs, boto3, requests, gradient_statsd, terminaltables
, click-completion , click-didyoumean, click-help-colors
, colorama, requests_toolbelt, gradient-utils, halo, progressbar2
, marshmallow, pyyaml, websocket_client
}:

buildPythonPackage rec {
  pname = "gradient";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15s21945hg342195ig7nchap5mdnsw931iis92pr7hy8ff0rks3n";
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
