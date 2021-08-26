{ lib
, attrs
, boto3
, buildPythonPackage
, click-completion
, click-didyoumean
, click-help-colors
, colorama
, fetchPypi
, gradient_statsd
, gradient-utils
, halo
, marshmallow
, progressbar2
, pyopenssl
, pyyaml
, requests
, requests-toolbelt
, terminaltables
, websocket-client
}:

buildPythonPackage rec {
  pname = "gradient";
  version = "1.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "108dc01d2f9f9d4fa2c080d12f14b77b4ec6329f239a0b2bc89e09360ae6757d";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'attrs<=' 'attrs>=' \
      --replace 'colorama==' 'colorama>=' \
      --replace 'PyYAML==' 'PyYAML>=' \
      --replace 'marshmallow<' 'marshmallow>=' \
      --replace 'websocket-client==' 'websocket-client>='
  '';

  propagatedBuildInputs = [
    attrs
    boto3
    click-completion
    click-didyoumean
    click-help-colors
    colorama
    gradient_statsd
    gradient-utils
    halo
    marshmallow
    progressbar2
    pyopenssl
    pyyaml
    requests
    requests-toolbelt
    terminaltables
    websocket-client
  ];

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  meta = with lib; {
    description = "The command line interface for Gradient";
    homepage = "https://github.com/Paperspace/gradient-cli";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
