{ stdenv, buildPythonPackage, fetchPypi, jinja2, werkzeug, flask, requests, pytz
, six, boto, httpretty, xmltodict, nose, sure, boto3, freezegun, dateutil }:

buildPythonPackage rec {
  pname = "moto";
  version = "0.4.31";
  name    = "moto-${version}";
  src = fetchPypi {
    inherit pname version;
    sha256 = "19s8hfz4mzzzdksa0ddlvrga5mxdaqahk89p5l29a5id8127shr8";
  };

  propagatedBuildInputs = [
    boto
    dateutil
    flask
    httpretty
    jinja2
    pytz
    werkzeug
    requests
    six
    xmltodict
  ];

  checkInputs = [ boto3 nose sure freezegun ];

  checkPhase = "nosetests";

  # TODO: make this true; I think lots of the tests want network access but we can probably run the others
  doCheck = false;
}
