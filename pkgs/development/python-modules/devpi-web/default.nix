{
  lib,
  attrs,
  beautifulsoup4,
  buildPythonPackage,
  defusedxml,
  devpi-common,
  devpi-server,
  docutils,
  fetchFromGitHub,
  gitUpdater,
  pygments,
  pyramid,
  pyramid-chameleon,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  readme-renderer,
  setuptools,
  tomli,
  webtest,
  whoosh,
}:

buildPythonPackage (finalAttrs: {
  pname = "devpi-web";
  version = "5.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    tag = "web-${finalAttrs.version}";
    hash = "sha256-p52uwkXeCPPsnD9BLfqEa8NK4bAfIdpYIzdNgmwucms=";
  };

  sourceRoot = "${finalAttrs.src.name}/web";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools_changelog_shortener"' ""
  '';

  build-system = [
    setuptools
  ];

  # some transitive deps incompatible <3.12
  disabled = pythonOlder "3.12";

  dependencies = [
    attrs
    beautifulsoup4
    defusedxml
    devpi-common
    devpi-server
    docutils
    pygments
    pyramid
    pyramid-chameleon
    readme-renderer
    readme-renderer.optional-dependencies.md
    tomli
    whoosh
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    webtest
  ];

  pythonImportsCheck = [ "devpi_web" ];

  # devpi uses a monorepo for server, common, client and web
  passthru.updateScript = gitUpdater {
    rev-prefix = "web-";
  };

  meta = {
    homepage = "https://github.com/devpi/devpi";
    description = "Web view for devpi-server";
    changelog = "https://github.com/devpi/devpi/blob/${finalAttrs.src.tag}/common/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      confus
    ];
  };
})
