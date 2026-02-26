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
  nix-update-script,
  pygments,
  pyramid,
  pyramid-chameleon,
  pytest-cov-stub,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  readme-renderer,
  setuptools,
  setuptools-changelog-shortener,
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

  build-system = [
    setuptools
    setuptools-changelog-shortener
  ];

  # build-system broken for 3.14, package incompatible <3.13
  disabled = pythonOlder "3.13" || pythonAtLeast "3.14";

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

  passthru.updateScript = nix-update-script { };

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
