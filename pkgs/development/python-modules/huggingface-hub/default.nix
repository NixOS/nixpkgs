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
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    rev = "v${version}";
    sha256 = "1pmi76vinwwn0bcxy5hj8pxhzqxdbzp0y3hsd631yyys01s0n6xd";
  };

  nativeBuildInputs = [ packaging ];

  propagatedBuildInputs = [
    filelock
    pyyaml
    requests
    ruamel-yaml
    tqdm
    typing-extensions
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
