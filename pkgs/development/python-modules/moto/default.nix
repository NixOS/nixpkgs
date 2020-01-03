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
, isPy38
}:

buildPythonPackage rec {
  pname = "moto";
  version = "1.3.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rhbjvqi1khp80gfnl3x632kwlpq3k7m8f13nidznixdpa78vm4m";
  };

  # 3.8 is not yet support
  # https://github.com/spulec/moto/pull/2519
  disabled = isPy38;

  # Backported fix from 1.3.14.dev for compatibility with botocore >= 1.9.198.
  patches = [
    (fetchpatch {
      url = "https://github.com/spulec/moto/commit/e4a4e6183560489e98b95e815b439c7a1cf3566c.diff";
      sha256 = "1fixr7riimnldiikv33z4jwjgcsccps0c6iif40x8wmpvgcfs0cb";
    })
  ];

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
    description = "Allows your tests to easily mock out AWS Services";
    homepage = https://github.com/spulec/moto;
    license = licenses.asl20;
    maintainers = [ ];
  };
}
