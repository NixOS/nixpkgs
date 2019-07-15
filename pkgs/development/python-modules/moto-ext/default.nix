{ pkgs
, buildPythonPackage
, fetchPypi
, boto3
, xmltodict
, mock
, werkzeug
, jinja2
, responses
, docker
, pyaml
, python-jose
, pytz
, cfn-lint
, aws-xray-sdk
, jsondiff
, boto
}:

buildPythonPackage rec {
  pname = "moto-ext";
  version = "1.3.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gvbni0a3s2m7vjjn7zvbzl4v7cnwp9jcw7pk39fldsznzdi9b0s";
  };

  buildInputs = [ boto3 xmltodict mock werkzeug jinja2 responses docker pyaml python-jose pytz cfn-lint aws-xray-sdk jsondiff boto ];

  doCheck = false;

  meta = with pkgs.lib; {
    homepage =https://github.com/spulec/moto;
    license = licenses.asl20;
    description = "Python tests to easily mock the boto library";
    maintainers = [ maintainers.mog ];
  };
}
