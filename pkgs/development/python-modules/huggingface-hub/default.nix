{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, filelock
, importlib-metadata
, packaging
, requests
, ruamel-yaml
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "huggingface-hub";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "huggingface_hub";
    rev = "v${version}";
    sha256 = "sha256-SxA7rAdKuSrSYFIuxG81lblPJOL69Yx4rBccVrbQa/g=";
  };

  nativeBuildInputs = [ packaging ];

  propagatedBuildInputs = [
    filelock
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
