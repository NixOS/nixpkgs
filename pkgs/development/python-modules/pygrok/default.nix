{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  regex,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygrok";
  version = "1.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "garyelephant";
    repo = "pygrok";
    tag = "v${finalAttrs.version}";
    hash = "sha256-leiQD5E5XYj7Q1LNW7FB4BnyNrgSGAiZzZqcXVk+iBw=";
  };

  build-system = [ setuptools ];

  dependencies = [ regex ];

  pythonImportsCheck = [ "pygrok" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    maintainers = with lib.maintainers; [ winpat ];
    description = "Python implementation of jordansissel's grok regular expression library";
    homepage = "https://github.com/garyelephant/pygrok";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
