{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "base36";
  version = "0.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tonyseek";
    repo = "python-base36";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jd9bQxTlb2ZsWmtHmCtx8FdWZMRqfvyFfnV+oNOs1hw=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "[pytest]" "[tool:pytest]" \
      --replace-fail "--pep8 --cov" ""
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test_base36.py" ];
  pythonImportsCheck = [ "base36" ];

  meta = {
    description = "Python implementation for the positional numeral system using 36 as the radix";
    homepage = "https://github.com/tonyseek/python-base36";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
