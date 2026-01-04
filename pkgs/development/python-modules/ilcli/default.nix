{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage {
  pname = "ilcli";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloudant";
    repo = "ilcli";
    # no tags
    rev = "2c033240a18603dd99c2dd8f6185ad0f0169c8c7";
    hash = "sha256-6aLkzpeS1xeIbTwFFIT7V1KWOaFLLq3opjIxnUuXOBE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ilcli" ];

  meta = {
    description = "I like command-line interfaces";
    homepage = "https://github.com/cloudant/ilcli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tochiaha ];
  };
}
