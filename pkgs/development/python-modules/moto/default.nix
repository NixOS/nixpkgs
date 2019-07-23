{ lib, buildPythonPackage, fetchPypi, isPy27
, aws-xray-sdk
, backports_tempfile
, boto
, boto3
, botocore
, cfn-lint
, docker
, flask
, freezegun
, jinja2
, jsondiff
, mock
, nose
, pyaml
, python-jose
, pytz
, requests
, responses
, six
, sshpubkeys
, sure
, werkzeug
, xmltodict
}:

buildPythonPackage rec {
  pname = "moto";
  version = "1.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vlq015irqqwdknk1an7qqkg1zjk18c7jd89r7zbxxfwy3bgzwwj";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "jsondiff==1.1.2" "jsondiff~=1.1"
    sed -i '/datetime/d' setup.py # should be taken care of by std library
  '';

  propagatedBuildInputs = [
    aws-xray-sdk
    boto
    boto3
    botocore
    cfn-lint
    docker
    flask # required for server
    jinja2
    jsondiff
    mock
    pyaml
    python-jose
    pytz
    six
    requests
    responses
    sshpubkeys
    werkzeug
    xmltodict
  ] ++ lib.optionals isPy27 [ backports_tempfile ];

  checkInputs = [ boto3 freezegun nose sure ];

  checkPhase = ''nosetests -v ./tests/ \
                  -e test_invoke_function_from_sns \
                  -e test_invoke_requestresponse_function \
                  -e test_context_manager \
                  -e test_decorator_start_and_stop'';

  meta = with lib; {
    description = "This project extends the Application Insights API surface to support Python";
    homepage = https://github.com/spulec/moto;
    license = licenses.asl20;
    maintainers = [ ];
  };
}
