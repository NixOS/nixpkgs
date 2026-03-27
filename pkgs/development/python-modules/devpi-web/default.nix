{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,

  # dependencies
  attrs,
  beautifulsoup4,
  defusedxml,
  devpi-common,
  devpi-server,
  docutils,
  pygments,
  pyramid,
  pyramid-chameleon,
  readme-renderer,
  setuptools,
  tomli,
  whoosh,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  packaging-legacy,
  webtest,
}:

buildPythonPackage (finalAttrs: {
  pname = "devpi-web";
  version = "5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    tag = "web-${finalAttrs.version}";
    hash = "sha256-rAku3oHcmzFNA/MP/64382gCTgqopwjjy4S4HTEFZiY=";
  };

  sourceRoot = "${finalAttrs.src.name}/web";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools_changelog_shortener"' ""
  '';

  build-system = [ setuptools ];

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
    tomli
    whoosh
  ]
  ++ readme-renderer.optional-dependencies.md;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    packaging-legacy
    webtest
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/devpi/devpi/issues/1114
    "test_dont_index_deleted_mirror"
  ];

  pythonImportsCheck = [ "devpi_web" ];

  # devpi uses a monorepo for server, common, client and web
  passthru = {
    # bulk updater selects wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      # devpi uses a monorepo for server, common, client and web
      rev-prefix = "web-";
    };
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
