{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  gitUpdater,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "buildstream-plugins-community";
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "BuildStream";
    repo = "buildstream-plugins-community";
    tag = version;
    hash = "sha256-Fvm7TKwKmOAiVATJrvvd9I5mpPN+zkCxaMXnoksVrJE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [ "buildstream_plugins_community" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    changelog = "https://gitlab.com/BuildStream/buildstream-plugins-community/-/tags/${version}";
    description = "A community-maintained collection of BuildStream 2 plugins that don't fit in with the core plugins for whatever reason.";
    homepage = "https://gitlab.com/BuildStream/buildstream-plugins-community";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ ownik ];
  };
}
