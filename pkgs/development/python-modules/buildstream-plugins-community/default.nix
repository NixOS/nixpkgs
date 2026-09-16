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
  version = "2.3.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "buildstream";
    repo = "buildstream-plugins-community";
    tag = finalAttrs.version;
    hash = "sha256-phBi5IxTEPWvBC0SszcQp3Q7rYmPihE79o/ftUD0+T0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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
