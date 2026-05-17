{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  versionCheckHook,
  which,
}:

buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "rtf-tokenize";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "rtf_tokenize";
    tag = finalAttrs.version;
    hash = "sha256-bM/DFl1mpHgeBItdyA5Tt+Eo9u82Gz+6qwft2h0bM94=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    which
  ];

  versionCheckProgramArg = "${placeholder "out"}/${python.sitePackages}";

  preInstallCheck = ''
    versionCheckProgram="$(which ls)"
  '';

  pythonImportsCheck = [ "rtf_tokenize" ];

  meta = {
    description = "Simple RTF tokenizer package for Python";
    homepage = "https://github.com/openstenoproject/rtf_tokenize";
    license = lib.licenses.gpl2Plus; # https://github.com/openstenoproject/rtf_tokenize/issues/1
    maintainers = with lib.maintainers; [
      pandapip1
      ShamrockLee
    ];
  };
})
