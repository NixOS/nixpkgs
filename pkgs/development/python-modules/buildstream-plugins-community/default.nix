{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  gitUpdater,
  setuptools,
  setuptools-scm,
  # Optional plugin dependencies, matching upstream's pyproject.toml extras.
  arpy,
  dulwich,
  packaging,
  requests,
  tomlkit,
}:
buildPythonPackage (finalAttrs: {
  pname = "buildstream-plugins-community";
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "buildstream";
    repo = "buildstream-plugins-community";
    tag = finalAttrs.version;
    hash = "sha256-Fvm7TKwKmOAiVATJrvvd9I5mpPN+zkCxaMXnoksVrJE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    arpy
    dulwich
    packaging
    requests
    tomlkit
  ];

  # Loaded by `bst` at runtime via pluginbase, so `buildstream` is always
  # present when imported; drop it here instead of propagating a second
  # `buildstream` closure into consumers that already bundle one.
  pythonRemoveDeps = [ "buildstream" ];

  pythonImportsCheck = [ "buildstream_plugins_community" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    changelog = "https://gitlab.com/BuildStream/buildstream-plugins-community/-/blob/${finalAttrs.src.tag}/NEWS";
    description = "BuildStream community plugins";
    homepage = "https://gitlab.com/buildstream/buildstream-plugins-community";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shymega ];
  };
})
