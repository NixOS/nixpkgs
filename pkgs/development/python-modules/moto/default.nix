{ lib, buildPythonPackage, fetchPypi, isPy27, fetchpatch
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
, parameterized
, idna
}:

buildPythonPackage rec {
  pname = "moto";
  version = "1.3.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fm09074qic24h8rw9a0paklygyb7xd0ch4890y4v8lj2pnsxbkr";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "jsondiff==1.1.2" "jsondiff~=1.1"
    sed -i '/datetime/d' setup.py # should be taken care of by std library
  '';

  patches = [
    # loosen idna upper limit
    (fetchpatch {
      url = "https://github.com/spulec/moto/commit/649b497f71cce95a6474a3ff6f3c9c3339efb68f.patch";
      sha256 = "03qdybzlskgbdadmlcg6ayxfp821b5iaa8q2542cwkcq7msqbbqc";
    })
  ];

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
    idna
  ] ++ lib.optionals isPy27 [ backports_tempfile ];

  checkInputs = [ boto3 freezegun nose sure parameterized ];

  checkPhase = ''
    nosetests -v ./tests/ \
              -e test_invoke_function_from_sns \
              -e test_invoke_requestresponse_function \
              -e test_context_manager \
              -e test_decorator_start_and_stop \
              -e test_invoke_event_function \
              -e test_invoke_function_from_dynamodb \
              -e test_invoke_function_from_sqs \
              -e test_invoke_lambda_error \
              -e test_invoke_async_function \
              -e test_passthrough_requests
  '';

  # Disabling because of 20 failing tests due to https://github.com/spulec/moto/issues/2728
  # We should enable these as soon as possible again though. Note the issue
  # is unrelated to the docutils 0.16 bump.
  doCheck = false;

  meta = with lib; {
    description = "Allows your tests to easily mock out AWS Services";
    homepage = "https://github.com/spulec/moto";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
