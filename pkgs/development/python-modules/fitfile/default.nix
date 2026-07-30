{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fitfile";
  version = "1.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tcgoetz";
    repo = "fit";
    tag = finalAttrs.version;
    hash = "sha256-NIshX/IkPmqviYRPT4wRF7evZwn9e7BdCI5x+2Pz7II=";
  };

  # fix metadata check hook
  postPatch = ''
    substituteInPlace ./fitfile/version_info.py --replace-fail \
      "(1, 0, 0)" "(1, 0, 1)"
  '';

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fitfile" ];

  meta = {
    description = "Python Fit file parser";
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/tcgoetz/fit";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
