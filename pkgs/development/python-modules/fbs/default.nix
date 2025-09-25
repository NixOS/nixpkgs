{
  lib,
  python,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  unittestCheckHook,
  rsa,
}:

buildPythonPackage rec {
  pname = "fbs";
  version = "1.2.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "mherrmann";
    repo = "fbs";
    tag = "v${version}";
    hash = "sha256-m7q0sW6/vo9JxnMGwlg3v2NzzV6wLnagYwpf+9SQa6w=";
  };

  pythonRemoveDeps = [ "pyinstaller" ];

  optional-dependencies = {
    licensing = [
      rsa
    ];
  };

  nativeCheckInputs = [
    setuptools
    unittestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  # For now, only the runtime package is actually working, because the `fbs`
  # project tooling is intentionally limited to python <= 3.6:
  # https://github.com/mherrmann/fbs/blob/dbd3854106de6c17e052b627fb3be5fc35989b0a/fbs/__init__.py#L24
  unittestFlagsArray = [ "tests/test_fbs_runtime" ];
  pythonImportsCheck = [ "fbs_runtime" ];

  # Not appropriate since we are not expecting to fulfill all dependencies of `fbs`, only `fbs_runtime`.
  # Also pythonRemoveDeps is not working properly.
  dontCheckRuntimeDeps = true;

  meta = {
    description = "Framework for creating cross-platform desktop applications with Python and Qt";
    homepage = "https://build-system.fman.io";
    license = lib.licenses.gpl3Plus;
    platforms = python.meta.platforms;
    changelog = "https://github.com/mherrmann/fbs/releases/tag/${src.tag}";
    maintainers = [ ];
  };
}
