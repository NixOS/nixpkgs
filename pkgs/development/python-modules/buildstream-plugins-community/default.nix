{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  gitUpdater,
  setuptools,
  setuptools-scm,
  buildstream,
}:

buildPythonPackage (finalAttrs: {
  pname = "buildstream-plugins-community";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "buildstream";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-lMolkThpd/axZI6B9zMENTznpvGq+2zo+ihC+dkknb8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # Do not run pyTest, causes infinite recursion as `buildstream-plugins`
  # depends on `Buildstream`, and vice-versa for tests.
  # May be fixable by skipping certain tests? TODO.

  pythonImportsCheck = [ "buildstream_plugins_community" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "BuildStream community plugins";
    homepage = "https://gitlab.com/buildstream/buildstream-plugins-community";
    inherit (buildstream.meta) platforms;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shymega ];
  };
})
