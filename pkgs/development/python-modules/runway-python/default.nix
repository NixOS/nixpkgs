{ lib
, buildPythonPackage
, pythonAtLeast
, fetchFromGitHub
, colorcet
, cryptography
, flask
, flask-compress
, flask-cors
, flask-sockets
, gevent
, imageio
, numpy
, pillow
, pyopenssl
, scipy
, six
, unidecode
, urllib3
, wget
, deepdiff
, pytest-cov
, pytestCheckHook
, pythonOlder
, websocket-client
}:

buildPythonPackage rec {
  pname = "runway-python";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "runwayml";
    repo = "model-sdk";
    rev = version;
    hash = "sha256-Qn+gsvxxUJee7k060lPk53qi15xwC/JORJ5aHKLigvM=";
  };

  propagatedBuildInputs = [
    colorcet
    cryptography
    flask
    flask-compress
    flask-cors
    flask-sockets
    gevent
    imageio
    numpy
    pillow
    pyopenssl
    scipy
    six
    unidecode
    urllib3
    wget
  ] ++ urllib3.optional-dependencies.secure;

  nativeCheckInputs = [
    deepdiff
    pytest-cov
    pytestCheckHook
    websocket-client
  ];

  postPatch = ''
    # Build fails with:
    # ERROR: No matching distribution found for urllib3-secure-extra; extra == "secure"
    substituteInPlace requirements.txt \
      --replace "urllib3[secure]>=1.25.7" "urllib3"
  '';

  disabledTests = [
    # These tests require network
    "test_file_deserialization_remote"
    "test_file_deserialization_absolute_directory"
    "test_file_deserialization_remote_directory"
    # Fails with a decoding error at the moment
    "test_inference_async"
  ] ++ lib.optionals (pythonAtLeast "3.9") [
    # AttributeError: module 'base64' has no attribute 'decodestring
    # https://github.com/runwayml/model-sdk/issues/99
    "test_image_serialize_and_deserialize"
    "test_segmentation_serialize_and_deserialize_colormap"
    "test_segmentation_serialize_and_deserialize_labelmap"
  ];

  pythonImportsCheck = [
    "runway"
  ];

  meta = {
    description = "Helper library for creating Runway models";
    homepage = "https://github.com/runwayml/model-sdk";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
