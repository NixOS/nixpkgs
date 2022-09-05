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
, gql
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
  version = "2.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D0JX6tk6SY5seH9m21hwMZ2TnaAG6OrHo+ucJEredd0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'attrs<=' 'attrs>=' \
      --replace 'colorama==' 'colorama>=' \
      --replace 'gql[requests]==3.0.0a6' 'gql' \
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
    gql
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

  # Tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  # marshmallow.exceptions.StringNotCollectionError: "only" should be a collection of strings.
  # Support for marshmallow > 3
  # pythonImportsCheck = [
  #   "gradient"
  # ];

  meta = with lib; {
    description = "The command line interface for Gradient";
    homepage = "https://github.com/Paperspace/gradient-cli";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
