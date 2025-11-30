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
  gitMinimal,
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
  ufomerge,
  unicodedata2,
  vharfbuzz,
}:

buildPythonPackage rec {
  pname = "fontbakery";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cLQNjrpk8m3Rm1VBC4FNGB7e/E+hjIqcStFSDqfVIk4=";
  };

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  pythonRelaxDeps = [
    "collidoscope"
    "freetype-py"
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
    ufomerge
    unicodedata2
    vharfbuzz
  ];

  nativeCheckInputs = [
    gitMinimal
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
    # These require network access
    "test_check_axes_match"
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
    "test_command_check_googlefonts"
    # AssertionError
    "test_check_shape_languages"
    "test_command_config_file"
    "test_config_override"
  ];

  disabledTestPaths = [
    # ValueError: Check 'googlefonts/glyphsets/shape_languages' not found
    "tests/test_checks_filesize.py"
    "tests/test_checks_googlefonts_overrides.py"
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
    mainProgram = "fontbakery";
    maintainers = with maintainers; [ danc86 ];
  };
}
