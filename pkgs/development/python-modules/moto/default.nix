{ buildPythonPackage, fetchPypi, jinja2, werkzeug, flask
, requests, pytz, backports_tempfile, cookies, jsondiff, botocore, aws-xray-sdk, docker, responses
, six, boto, httpretty, xmltodict, nose, sure, boto3, freezegun, dateutil, mock, pyaml, python-jose }:

buildPythonPackage rec {
  pname = "moto";
  version = "1.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "129de2e04cb250d9f8b2c722ec152ed1b5426ef179b4ebb03e9ec36e6eb3fcc5";
  };

  postPatch = ''
    # regarding aws-xray-sdk: https://github.com/spulec/moto/commit/31eac49e1555c5345021a252cb0c95043197ea16
    # regarding python-jose: https://github.com/spulec/moto/pull/1927
    substituteInPlace setup.py \
      --replace "aws-xray-sdk<0.96," "aws-xray-sdk" \
      --replace "jsondiff==1.1.1" "jsondiff>=1.1.1" \
      --replace "python-jose<3.0.0" "python-jose<4.0.0"
  '';

  propagatedBuildInputs = [
    aws-xray-sdk
    boto
    boto3
    dateutil
    flask
    httpretty
    jinja2
    pytz
    werkzeug
    requests
    six
    xmltodict
    mock
    pyaml
    backports_tempfile
    cookies
    jsondiff
    botocore
    docker
    responses
    python-jose
  ];

  checkInputs = [ boto3 nose sure freezegun ];

  checkPhase = "nosetests";

  # TODO: make this true; I think lots of the tests want network access but we can probably run the others
  doCheck = false;
}
