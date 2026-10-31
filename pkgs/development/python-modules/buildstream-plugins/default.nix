{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  cython,
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

  # Do not run pyTest, causes infinite recursion as `buildstream-plugins`
  # depends on `Buildstream`, and vice-versa for tests.
  # May be fixable by skipping certain tests? TODO.

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
