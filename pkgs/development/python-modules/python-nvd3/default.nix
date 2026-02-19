{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-slugify,
  jinja2,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-nvd3";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "areski";
    repo = "python-nvd3";
    tag = "v${version}";
    hash = "sha256-+J0lHAOjX3hbymjESQ6WpEnly+1Lv9o0ucIpBxTuS6s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-slugify
    jinja2
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests.py" ];

  meta = {
    description = "Python Wrapper for NVD3";
    homepage = "https://github.com/areski/python-nvd3";
    changelog = "https://github.com/areski/python-nvd3/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivan-tkatchev ];
    mainProgram = "nvd3";
  };
}
