{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dlinfo";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fphammerle";
    repo = "python-dlinfo";
    tag = "v${version}";
    hash = "sha256-W9WfXU5eIMQQImzRgTJS0KL4IZfRtLrK8TYmdEc0VLI=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths =
    if stdenv.hostPlatform.isDarwin then
      [
        "tests/dlinfo_macosx_mock_test.py"
      ]
    else
      [ "tests/dlinfo_glibc_test.py" ];

  pythonImportsCheck = [ "dlinfo" ];

  # all tests are broken, see:
  # https://github.com/fphammerle/python-dlinfo/pull/64
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    changelog = "https://github.com/fphammerle/python-dlinfo/blob/${src.tag}/CHANGELOG.md";
    description = "Python wrapper for libc's dlinfo and dyld_find on Mac";
    homepage = "https://github.com/fphammerle/python-dlinfo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
