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
  version = "1.8.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fa4a0553c28839e364d3aac27ec7292d26c1df27b8c54701d57eb7eda0b14f2";
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
    # There is no support for click > 8
    # https://github.com/Paperspace/gradient-cli/issues/368
    broken = true;
  };
}
