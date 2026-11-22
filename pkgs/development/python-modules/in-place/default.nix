{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "in-place";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "inplace";
    tag = "v${version}";
    hash = "sha256-oko4yDqkxVWGri315HenqfLjoUqmauO1bSaDh8cBK4s=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "in_place" ];

  meta = {
    description = "In-place file processing";
    homepage = "https://github.com/jwodder/inplace";
    changelog = "https://github.com/jwodder/inplace/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
