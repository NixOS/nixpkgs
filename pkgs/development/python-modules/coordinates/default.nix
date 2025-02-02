{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "coordinates";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "clbarnes";
    repo = "coordinates";
    rev = "refs/tags/v${version}";
    hash = "sha256-S/AmH5FinTpHFFcrGAUSyjfqoIgq14QlHk9CnUkqCv4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "coordinates" ];

  meta = with lib; {
    description = "Convenience class for doing maths with explicit coordinates";
    homepage = "https://github.com/clbarnes/coordinates";
    changelog = "https://github.com/clbarnes/coordinates/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
