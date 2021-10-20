{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, filelock
, importlib-metadata
, requests
, tqdm
}:

buildPythonPackage rec {
  pname = "huggingface-hub";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    rev = "v${version}";
    hash = "sha256-0DSgWmodeRmvGq2v3n86BzRx5Xdb8fIQh+G/2O2d+yo=";
  };

  propagatedBuildInputs = [
    filelock
    requests
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # Tests require network access.
  doCheck = false;
  pythonImportsCheck = [ "huggingface_hub" ];

   meta = with lib; {
    homepage = "https://github.com/huggingface/huggingface_hub";
    description = "Download and publish models and other files on the huggingface.co hub";
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
