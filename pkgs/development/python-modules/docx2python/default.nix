{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  paragraphs,
  pytestCheckHook,
  types-lxml,
  typing-extensions,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "docx2python";
  version = "3.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ShayHill";
    repo = "docx2python";
    tag = finalAttrs.version;
    hash = "sha256-ctMx5UpQr8QEzB0+CahmGN2PdbFrEzoJ4Tu8LGi3GMM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.25,<0.12.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    lxml
    paragraphs
    types-lxml
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "docx2python" ];

  meta = {
    description = "Extract docx headers, footers, (formatted) text, footnotes, endnotes, properties, and images";
    homepage = "https://github.com/ShayHill/docx2python";
    changelog = "https://github.com/ShayHill/docx2python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
