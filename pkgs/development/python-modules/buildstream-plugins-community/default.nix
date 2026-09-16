{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools-scm,
  buildstream,
}:

buildPythonPackage (finalAttrs: {
  pname = "buildstream-plugins-community";
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "BuildStream";
    repo = "buildstream-plugins-community";
    tag = finalAttrs.version;
    hash = "sha256-Fvm7TKwKmOAiVATJrvvd9I5mpPN+zkCxaMXnoksVrJE=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    buildstream
  ];

  meta = {
    description = "BuildStream community plugins";
    homepage = "https://gitlab.com/BuildStream/buildstream-plugins-community";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ maxmosk ];
  };
})
