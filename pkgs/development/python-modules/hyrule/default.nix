{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hyrule";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hylang";
    repo = "hyrule";
    tag = version;
    hash = "sha256-9h6Jo+etK5DBeQ5CzClnvBnaH3TvY9/9jW9zbVbEJLQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ hy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Some tests depends on hy on PATH
  preCheck = "PATH=${hy}/bin:$PATH";

  pythonImportsCheck = [ "hyrule" ];

  meta = {
    description = "Utility library for the Hy programming language";
    homepage = "https://github.com/hylang/hyrule";
    changelog = "https://github.com/hylang/hyrule/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
