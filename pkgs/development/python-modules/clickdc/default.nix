{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  typing-extensions,
  setuptools,
  setuptools-git-versioning,
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
    setuptools-git-versioning
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'setuptools-git-versioning<2' 'setuptools-git-versioning'
  '';

  dependencies = [
    click
    typing-extensions
  ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
  ];

  # Tests require click < 8.2 (removed CliRunner's mix_stderr parameter)
  # TODO: re-enable once clickdc supports click >= 8.2
  doCheck = false;

  pythonImportsCheck = [ "clickdc" ];

  meta = {
    description = "Define click command line options from a python dataclass";
    homepage = "https://github.com/Kamilcuk/clickdc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
  };
})
