{ buildPythonPackage
, einops
, fetchFromGitHub
, jax
, jaxlib
, lib
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "augmax";
  version = "0.3.1";
  pyproject = true;

  disbaled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "khdlr";
    repo = "augmax";
    rev = "refs/tags/v${version}";
    hash = "sha256-hDNNoE7KVaH3jrXZA4A8f0UoQJPl6KHA3XwMc3Ccohk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ einops jax ];

  # augmax does not have any tests at the time of writing (2022-02-19), but
  # jaxlib is necessary for the pythonImportsCheckPhase.
  nativeCheckInputs = [ jaxlib ];

  pythonImportsCheck = [ "augmax" ];

  meta = with lib; {
    description = "Efficiently Composable Data Augmentation on the GPU with Jax";
    homepage = "https://github.com/khdlr/augmax";
    changelog = "https://github.com/khdlr/augmax/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
