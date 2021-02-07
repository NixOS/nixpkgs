{ lib
, fetchFromGitHub
, buildPythonPackage
, attrs
, boto3
, click-completion
, click-didyoumean
, click-help-colors
, colorama
, gradient-utils
, gradient_statsd
, halo
, marshmallow
, progressbar2
, pyyaml
, requests
, requests_toolbelt
, terminaltables
, websocket_client
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "gradient";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "Paperspace";
    repo = "gradient-cli";
    rev = "v${version}";
    sha256 = "1w8607j3wzgjvzszkl72glax0jg34gga90mkvv6awi7r9va9p30m";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'attrs<=' 'attrs>=' \
      --replace 'colorama==' 'colorama>=' \
      --replace 'PyYAML==' 'PyYAML>=' \
      --replace 'marshmallow<' 'marshmallow>='
  '';

  propagatedBuildInputs = [
    attrs
    boto3
    requests
    gradient_statsd
    terminaltables
    click-completion
    click-didyoumean
    click-help-colors
    requests_toolbelt
    colorama
    gradient-utils
    halo
    marshmallow
    progressbar2
    pyyaml
    websocket_client
  ];

  checkInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "gradient" ];

  meta = with lib; {
    description = "The command line interface for Gradient";
    homepage = "https://github.com/Paperspace/gradient-cli";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
