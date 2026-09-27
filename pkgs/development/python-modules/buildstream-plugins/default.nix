{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  cython,
  buildstream,
  gitMinimal,
  pytestCheckHook,
  pytest-datafiles,
  pytest-env,
}:

buildPythonPackage (finalAttrs: {
  pname = "buildstream-plugins";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "buildstream-plugins";
    tag = finalAttrs.version;
    hash = "sha256-9FlSgGOSXhSAyVwVIRzd+rc1PytxKmrss36dxaswKvs=";
  };

  build-system = [
    cython
    setuptools
  ];

  # `buildstream-plugins` is loaded by `buildstream` at runtime, so it
  # will always have `buildstream` in its environment when imported; it
  # is not declared as a `dependencies` entry here since `buildstream`
  # bundles `buildstream-plugins` by default, which would otherwise
  # cause infinite recursion between the two packages.
  nativeCheckInputs = [
    (buildstream.override { enableBuildstreamPlugins = false; })
    gitMinimal
    pytestCheckHook
    pytest-datafiles
    pytest-env
  ];

  # These tests fetch from the network (Docker Hub, crates.io) or build
  # elements in a sandbox, neither of which are available in the Nix
  # build sandbox. Everything else marked `integration` is already
  # skipped by the upstream test suite unless `--integration` is passed.
  disabledTestPaths = [
    "tests/sources/cargo.py"
    "tests/sources/docker.py"
  ];

  pythonImportsCheck = [ "buildstream_plugins" ];

  passthru.updateScript = gitUpdater {
    ignoredVersions = "dev";
  };

  meta = {
    changelog = "https://github.com/apache/buildstream-plugins/blob/${finalAttrs.src.tag}/NEWS";
    description = "BuildStream plugins";
    homepage = "https://github.com/apache/buildstream-plugins";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shymega ];
  };
})
