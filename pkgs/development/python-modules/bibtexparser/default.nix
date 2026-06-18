{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyparsing,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bibtexparser";
  version = "1.4.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sciunto-org";
    repo = "python-${finalAttrs.pname}";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9zLJZAk2IBYTL7lACh6erY7A44XFZGJCr8dcpYlwKRI=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyparsing ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bibtexparser" ];

  meta = {
    description = "Bibtex parser for Python";
    homepage = "https://github.com/sciunto-org/python-bibtexparser";
    license = with lib.licenses; [
      lgpl3Only # or
      bsd3
    ];
  };
})
