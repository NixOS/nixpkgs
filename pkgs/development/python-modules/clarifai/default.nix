{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, clarifai-grpc
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clarifai";
  version = "9.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Clarifai";
    repo = "clarifai-python-utils";
    rev = "refs/tags/${version}";
    hash = "sha256-29by0YAQ7qc0gL/3lAFOk4FLDB5Qv4X9QDyK49gfyAo=";
  };

  propagatedBuildInputs = [
    clarifai-grpc
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "clarifai" ];

  meta = with lib; {
    description = "Clarifai Python Utilities";
    homepage = "https://github.com/Clarifai/clarifai-python-utils";
    changelog = "https://github.com/Clarifai/clarifai-python-utils/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
