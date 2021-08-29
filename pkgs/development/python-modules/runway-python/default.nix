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
, pytestCheckHook
, pytestcov
, websocket_client
}:

buildPythonPackage rec {
  pname = "runway-python";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "runwayml";
    repo = "model-sdk";
    rev = version;
    sha256 = "1ww2wai1qnly8i7g42vhkkbs4yp7wi9x4fjdxsg9fl3izjra0zs2";
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
  ];

  pythonImportsCheck = [
    "runway"
  ];

  checkInputs = [
    deepdiff
    pytestCheckHook
    pytestcov
    websocket_client
  ];

  disabledTests = [
    # these tests require network
    "test_file_deserialization_remote"
    "test_file_deserialization_absolute_directory"
    "test_file_deserialization_remote_directory"
  ] ++ lib.optionals (pythonAtLeast "3.9") [
     # AttributeError: module 'base64' has no attribute 'decodestring
     # https://github.com/runwayml/model-sdk/issues/99
     "test_image_serialize_and_deserialize"
     "test_segmentation_serialize_and_deserialize_colormap"
     "test_segmentation_serialize_and_deserialize_labelmap"
  ];

  meta = {
    description = "Helper library for creating Runway models";
    homepage = "https://github.com/runwayml/model-sdk";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
