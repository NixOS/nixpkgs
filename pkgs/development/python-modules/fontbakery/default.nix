{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  axisregistry,
  babelfont,
  beautifulsoup4,
  beziers,
  cmarkgfm,
  collidoscope,
  defcon,
  dehinter,
  fonttools,
  font-v,
  freetype-py,
  gflanguages,
  gfsubsets,
  git,
  glyphsets,
  lxml,
  installShellFiles,
  jinja2,
  munkres,
  opentypespec,
  ots-python,
  packaging,
  pip-api,
  protobuf,
  pytestCheckHook,
  pytest-xdist,
  pyyaml,
  requests,
  requests-mock,
  rich,
  setuptools,
  setuptools-scm,
  shaperglot,
  stringbrewer,
  toml,
  unicodedata2,
  ufo2ft,
  ufolint,
  vharfbuzz,
}:

buildPythonPackage rec {
  pname = "fontbakery";
  version = "0.12.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DN1v5MQtMhHO12tVPkJUuIfh+X3kb1o71zAwNgtLH+I=";
  };

  pyproject = true;

  dependencies = [
    axisregistry
    babelfont
    beautifulsoup4
    beziers
    cmarkgfm
    collidoscope
    defcon
    dehinter
    fonttools
    font-v
    freetype-py
    gflanguages
    gfsubsets
    glyphsets
    lxml
    jinja2
    munkres
    ots-python
    opentypespec
    packaging
    pip-api
    protobuf
    pyyaml
    requests
    rich
    shaperglot
    stringbrewer
    toml
    ufolint
    unicodedata2
    vharfbuzz
    ufo2ft
  ];
  build-system = [
    setuptools
    setuptools-scm
  ];
  nativeBuildInputs = [
    installShellFiles
  ];

  pythonRelaxDeps = [
    "collidoscope"
    "protobuf"
    "vharfbuzz"
  ];

  doCheck = true;
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
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
