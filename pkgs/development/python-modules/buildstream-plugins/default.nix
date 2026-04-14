{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  cython,
  buildstream,
}:

buildPythonPackage rec {
  pname = "buildstream-plugins";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "buildstream-plugins";
    tag = version;
    hash = "sha256-vbHfceMdaedAg0fVt8pBF+S7yPYhfQlgEYvb48ym+4I=";
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
    description = "BuildStream plugins";
    homepage = "https://github.com/apache/buildstream-plugins";
    inherit (buildstream.meta) platforms;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shymega ];
  };
}
