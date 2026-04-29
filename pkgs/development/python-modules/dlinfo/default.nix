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

  # The glibc test asserts that resolved library paths exist on disk, which
  # fails on macOS where system libraries live in a shared cache since Big
  # Sur and /usr/lib/lib*.dylib are no longer real files.  The macOS mock
  # test (dlinfo_macosx_mock_test.py) already handles this case correctly.
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "tests/dlinfo_glibc_test.py"
  ];

  pythonImportsCheck = [ "dlinfo" ];

  meta = {
    changelog = "https://github.com/fphammerle/python-dlinfo/blob/${src.tag}/CHANGELOG.md";
    description = "Python wrapper for libc's dlinfo and dyld_find on Mac";
    homepage = "https://github.com/fphammerle/python-dlinfo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
