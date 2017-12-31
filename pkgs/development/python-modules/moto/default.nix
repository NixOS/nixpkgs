{ stdenv, buildPythonPackage, fetchPypi, jinja2, werkzeug, flask
, requests, pytz, backports_tempfile, cookies, jsondiff, botocore, aws-xray-sdk, docker
, six, boto, httpretty, xmltodict, nose, sure, boto3, freezegun, dateutil, mock, pyaml }:

buildPythonPackage rec {
  pname = "moto";
  version = "1.1.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d427d6e1a81e926c2b6a071453807b05f4736d65068493e1f3055ac7ee24ea21";
  };

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
  ];

  checkInputs = [ boto3 nose sure freezegun ];

  checkPhase = "nosetests";

  # TODO: make this true; I think lots of the tests want network access but we can probably run the others
  doCheck = false;
}
