{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "coordinates";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clbarnes";
    repo = "coordinates";
    tag = "v${version}";
    hash = "sha256-S/AmH5FinTpHFFcrGAUSyjfqoIgq14QlHk9CnUkqCv4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "coordinates" ];

  meta = {
    description = "Convenience class for doing maths with explicit coordinates";
    homepage = "https://github.com/clbarnes/coordinates";
    changelog = "https://github.com/clbarnes/coordinates/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
