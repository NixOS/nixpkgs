{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, clarifai-grpc
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clarifai";
  version = "9.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Clarifai";
    repo = "clarifai-python-utils";
    rev = "refs/tags/${version}";
    hash = "sha256-/zgHgD2kf3ZG7Mu9AEBfOwqpcD0Ye0LVrFxLeuGurCM=";
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
