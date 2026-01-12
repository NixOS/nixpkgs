{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  emoji,
}:

buildPythonPackage rec {
  pname = "emoji-country-flag";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cvzi";
    repo = "flag";
    tag = "v${version}";
    hash = "sha256-Te3RJ+rHkr3q93C7hLE5xCZz91QC2IsFR0FluVEJOv4=";
  };

  build-system = [
    setuptools
  ];

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
    emoji
  ];

  pythonImportsCheck = [ "flag" ];

  meta = {
    description = "Flag emoji from country codes for Python";
    homepage = "https://github.com/cvzi/flag";
    changelog = "https://github.com/cvzi/flag/releases/tag/v${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      skohtv
      aleksana
    ];
  };
}
