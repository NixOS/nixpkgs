{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  cython,
  pythonOlder,
  requests,
  tomli,
}:
buildPythonPackage rec {
  pname = "buildstream-plugins";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "buildstream-plugins";
    tag = version;
    hash = "sha256-9FlSgGOSXhSAyVwVIRzd+rc1PytxKmrss36dxaswKvs=";
  };

  build-system = [
    cython
    setuptools
  ];

  # Per-plugin extras, matching requirements/plugin-requirements.txt upstream:
  # these are only needed by users of the corresponding source/element, not by
  # buildstream-plugins itself, so they're kept optional rather than forced on
  # everyone via `dependencies`.
  optional-dependencies = {
    # Cargo source: only needed on Python < 3.11, which lacks stdlib tomllib.
    cargo = lib.optionals (pythonOlder "3.11") [ tomli ];
    # Docker source.
    docker = [ requests ];
  };

  # Do not run pyTest, causes infinite recursion as `buildstream-plugins`
  # depends on `Buildstream`, and vice-versa for tests.
  # May be fixable by skipping certain tests? TODO.

  pythonImportsCheck = [ "buildstream_plugins" ];

  passthru.updateScript = gitUpdater {
    ignoredVersions = "dev";
  };

  meta = {
    changelog = "https://github.com/apache/buildstream-plugins/releases/tag/${version}";
    description = "BuildStream plugins";
    homepage = "https://github.com/apache/buildstream-plugins";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shymega ];
  };
}
