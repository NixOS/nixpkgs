{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, filelock
, fsspec
, packaging
, pyyaml
, requests
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "huggingface-hub";
  version = "0.20.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    rev = "refs/tags/v${version}";
    hash = "sha256-21Ay8RVS2vtQIh4bBUxE8jFk6F+yeFBJ3XgvRRNtNgI=";
  };

  propagatedBuildInputs = [
    filelock
    fsspec
    packaging
    pyyaml
    requests
    tqdm
    typing-extensions
  ];

  # Tests require network access.
  doCheck = false;

  pythonImportsCheck = [
    "huggingface_hub"
  ];

  meta = with lib; {
    description = "Download and publish models and other files on the huggingface.co hub";
    homepage = "https://github.com/huggingface/huggingface_hub";
    changelog = "https://github.com/huggingface/huggingface_hub/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
