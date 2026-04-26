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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = "rtf_tokenize";
    tag = finalAttrs.version;
    hash = "sha256-zwD2sRYTY1Kmm/Ag2hps9VRdUyQoi4zKtDPR+F52t9A=";
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
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
