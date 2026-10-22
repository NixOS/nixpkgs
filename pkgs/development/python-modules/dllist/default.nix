{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dllist";
  version = "2.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "WardBrian";
    repo = "dllist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jCAxL7jfF3ty+3PwOFQgXCXmRWDcXZ9sXUJg0EmTEGI=";
  };

  build-system = [ setuptools ];

  # test_euler is skipped: it needs the test extension in test/test_éxt, which isn't built.
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dllist" ];

  meta = {
    description = "List the shared libraries loaded by the current process";
    homepage = "https://github.com/WardBrian/dllist";
    changelog = "https://github.com/WardBrian/dllist/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ connorbaker ];
  };
})
