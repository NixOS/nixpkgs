{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "extra-platforms";
  version = "14.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kdeldycke";
    repo = "extra-platforms";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y8LFZtkhEdXk7Ueohb//WbSxswoR+L9aTxe0IeM5hn8=";
  };

  build-system = [ uv-build ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests marked ``network`` reach out to PyPI; the build sandbox has no
  # system TLS CA bundle.
  disabledTestMarks = [ "network" ];

  # tests/test_trait.py imports click_extra, which depends on this package, so
  # the suite cannot run at build time without a cycle. Nothing else in the
  # module is reachable, pytest failing at collection.
  disabledTestPaths = [ "tests/test_trait.py" ];

  pythonImportsCheck = [ "extra_platforms" ];

  meta = {
    description = "Detect platforms, architectures and OS families";
    homepage = "https://github.com/kdeldycke/extra-platforms";
    changelog = "https://github.com/kdeldycke/extra-platforms/blob/v${finalAttrs.version}/changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kdeldycke ];
  };
})
