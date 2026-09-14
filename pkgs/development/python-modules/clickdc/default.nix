{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  typing-extensions,
  setuptools,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "clickdc";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kamilcuk";
    repo = "clickdc";
    tag = finalAttrs.version;
    hash = "sha256-pOMArEWmoDTWZWSK7IemuqP+lSqOZgzzP6xKtmpOS90=";
  };

  build-system = [
    setuptools
  ];

  postPatch = ''
        substituteInPlace pyproject.toml \
          --replace-fail '"setuptools-git-versioning<2",' "" \
          --replace-fail 'dynamic = ["version", "dependencies", "optional-dependencies"]' 'version = "0.1.1"
    dynamic = ["dependencies", "optional-dependencies"]'
  '';

  dependencies = [
    click
    typing-extensions
  ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
  ];

  pythonImportsCheck = [ "clickdc" ];

  # upstream tests require pyright (unavailable) and an older click API
  # (CliRunner(mix_stderr=...) was removed in click 8.2)
  doCheck = false;

  meta = {
    description = "Define click command line options from a python dataclass";
    homepage = "https://github.com/Kamilcuk/clickdc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
  };
})
