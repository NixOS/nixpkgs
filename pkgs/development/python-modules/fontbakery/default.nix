{
  lib,
  axisregistry,
  babelfont,
  beautifulsoup4,
  beziers,
  buildPythonPackage,
  callPackage,
  cmarkgfm,
  collidoscope,
  defcon,
  dehinter,
  fetchPypi,
  font-v,
  fonttools,
  freetype-py,
  gflanguages,
  gfsubsets,
  git,
  glyphsets,
  installShellFiles,
  jinja2,
  lxml,
  munkres,
  opentypespec,
  ots-python,
  packaging,
  pip-api,
  protobuf,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests-mock,
  requests,
  rich,
  setuptools-scm,
  setuptools,
  shaperglot,
  stringbrewer,
  toml,
  ufo2ft,
  ufolint,
  unicodedata2,
  vharfbuzz,
}:

buildPythonPackage rec {
  pname = "fontbakery";
  version = "0.12.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cl0jRQqF83IIldkp1VuVSS4ZeVsQH1NNpyEkpMJqhA8=";
  };

  pythonRelaxDeps = [
    "collidoscope"
    "protobuf"
    "vharfbuzz"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  dependencies = [
    axisregistry
    babelfont
    beautifulsoup4
    beziers
    cmarkgfm
    collidoscope
    defcon
    dehinter
    font-v
    fonttools
    freetype-py
    gflanguages
    gfsubsets
    glyphsets
    jinja2
    lxml
    munkres
    opentypespec
    ots-python
    packaging
    pip-api
    protobuf
    pyyaml
    requests
    rich
    shaperglot
    stringbrewer
    toml
    ufo2ft
    ufolint
    unicodedata2
    vharfbuzz
  ];

  nativeCheckInputs = [
    git
    pytestCheckHook
    pytest-xdist
    requests-mock
    ufolint
  ];

  preCheck = ''
    # Let the tests invoke 'fontbakery' command.
    export PATH="$out/bin:$PATH"
    # font-v tests assume they are running from a git checkout, although they
    # don't care which one. Create a dummy git repo to satisfy the tests:
    git init -b main
    git config user.email test@example.invalid
    git config user.name Test
    git commit --allow-empty --message 'Dummy commit for tests'
  '';

  disabledTests = [
    # These require network access:
    "test_check_description_broken_links"
    "test_check_description_family_update"
    "test_check_metadata_designer_profiles"
    "test_check_metadata_has_tags"
    "test_check_metadata_includes_production_subsets"
    "test_check_vertical_metrics"
    "test_check_vertical_metrics_regressions"
    "test_check_cjk_vertical_metrics"
    "test_check_cjk_vertical_metrics_regressions"
    "test_check_fontbakery_version_live_apis"
  ];

  postInstall = ''
    installShellCompletion --bash --name fontbakery \
      snippets/fontbakery.bash-completion
  '';

  passthru.tests.simple = callPackage ./tests.nix { };

  meta = with lib; {
    description = "Tool for checking the quality of font projects";
    homepage = "https://github.com/googlefonts/fontbakery";
    changelog = "https://github.com/fonttools/fontbakery/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
