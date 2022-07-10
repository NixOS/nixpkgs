{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, filelock
, importlib-metadata
, packaging
, pyyaml
, requests
, ruamel-yaml
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "huggingface-hub";
  version = "0.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    rev = "refs/tags/v${version}";
    hash = "sha256-XerI4dkGsnxbOE1Si70adVIwLIrStZ3HSuQPAQoJtnQ=";
  };

  propagatedBuildInputs = [
    filelock
    packaging
    pyyaml
    requests
    ruamel-yaml
    tqdm
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
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
    maintainers = with maintainers; [ ];
  };
}
