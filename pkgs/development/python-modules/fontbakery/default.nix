{
  lib,
  axisregistry,
  beautifulsoup4,
  beziers,
  buildPythonPackage,
  callPackage,
  cmarkgfm,
  collidoscope,
  defcon,
  dehinter,
  fetchFromGitHub,
  fonttools,
  freetype-py,
  gflanguages,
  gfsubsets,
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
  unicodedata2,
  uharfbuzz,
  vharfbuzz,
  myst-parser,
  sphinx,
  sphinx-rtd-theme,
  pytest-cov-stub,
  pylint,
  black,
}:

buildPythonPackage (finalAttrs: {
  pname = "fontbakery";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "fontbakery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IkGcaRW8RjwR/foACR38HtCuETyXTyCjpIUaY+awMQo=";
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
    beziers
    cmarkgfm
    defcon
    dehinter
    fonttools
    freetype-py
    jinja2
    munkres
    opentypespec
    ots-python
    packaging
    pip-api
    pyyaml
    requests
    rich
    toml
    ufo2ft
    ufolint
    uharfbuzz
    vharfbuzz
  ]
  ++ fonttools.optional-dependencies.ufo;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    ufolint
    pytest-cov-stub
    requests-mock
    pylint
    black
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  optional-dependencies = {
    beautifulsoup4 = [ beautifulsoup4 ];
    shaperglot = [ shaperglot ];
    googlefontsalwayslatest = [
      axisregistry
      gflanguages
      gfsubsets
      glyphsets
      shaperglot
    ];
    adobefonts = [ ];
    fontval = [ lxml ];
    fontwerk = finalAttrs.passthru.optional-dependencies.googlefonts;
    googlefonts = [
      collidoscope
      fonttools
      protobuf
      stringbrewer
      unicodedata2
    ]
    ++ fonttools.optional-dependencies.lxml
    ++ fonttools.optional-dependencies.unicode
    ++ finalAttrs.passthru.optional-dependencies.beautifulsoup4
    ++ finalAttrs.passthru.optional-dependencies.googlefontsalwayslatest
    ++ finalAttrs.passthru.optional-dependencies.shaperglot;
    iso15008 = [ ];
    microsoft = [ ];
    notofonts = finalAttrs.passthru.optional-dependencies.googlefonts;
    typenetwork = [
      unicodedata2
    ]
    ++ finalAttrs.passthru.optional-dependencies.beautifulsoup4
    ++ finalAttrs.passthru.optional-dependencies.shaperglot;
    docs = [
      myst-parser
      sphinx
      sphinx-rtd-theme
    ];
    all =
      finalAttrs.passthru.optional-dependencies.docs
      ++ finalAttrs.passthru.optional-dependencies.adobefonts
      ++ finalAttrs.passthru.optional-dependencies.fontval
      ++ finalAttrs.passthru.optional-dependencies.fontwerk
      ++ finalAttrs.passthru.optional-dependencies.googlefonts
      ++ finalAttrs.passthru.optional-dependencies.iso15008
      ++ finalAttrs.passthru.optional-dependencies.notofonts
      ++ finalAttrs.passthru.optional-dependencies.typenetwork;
  };

  preCheck = ''
    # Let the tests invoke 'fontbakery' command.
    export PATH="$out/bin:$PATH"
  '';

  disabledTests = [
    # These require network access
    "test_check_axes_match"
    "test_check_vertical_metrics_regressions"
  ];

  postInstall = ''
    installShellCompletion --bash --name fontbakery \
      snippets/fontbakery.bash-completion
  '';

  passthru.tests.simple = callPackage ./tests.nix { };

  meta = {
    description = "Tool for checking the quality of font projects";
    homepage = "https://github.com/googlefonts/fontbakery";
    changelog = "https://github.com/fonttools/fontbakery/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "fontbakery";
    maintainers = with lib.maintainers; [
      danc86
      jopejoe1
    ];
  };
})
