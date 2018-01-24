{ stdenv, buildPythonPackage, fetchPypi, jinja2, werkzeug, flask
, requests, pytz, backports_tempfile, cookies, jsondiff, botocore, aws-xray-sdk, docker
, six, boto, httpretty, xmltodict, nose, sure, boto3, freezegun, dateutil, mock, pyaml }:

buildPythonPackage rec {
  pname = "moto";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c42b894cdf35412c95f0c6b40309cf802436e049cd172dc5db7516c7b845191b";
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
