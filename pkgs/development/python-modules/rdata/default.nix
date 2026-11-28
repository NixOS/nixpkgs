{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  xarray,
  pandas,
  typing-extensions,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "rdata";
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vnmabus";
    repo = "rdata";
    tag = finalAttrs.version;
    hash = "sha256-XahRMgXzLNB8AW7lJ5K1t9mp2pAs3tCY9mEJa1t1dpE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    xarray
    pandas
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python library for R datasets";
    homepage = "https://github.com/vnmabus/rdata";
    changelog = "https://github.com/vnmabus/rdata/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ haansn08 ];
    platforms = lib.platforms.all;
  };
})
