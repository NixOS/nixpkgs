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

  # The glibc test asserts that resolved library paths exist as files on
  # disk.  On macOS since Big Sur, system libraries live in a shared dyld
  # cache and /usr/lib/lib*.dylib are no longer real files, causing the
  # assertion to fail.  The macOS-specific mock test still runs and covers
  # the Darwin codepath.
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
