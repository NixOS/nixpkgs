{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  gitUpdater,
  pytestCheckHook,
  black,
  setuptools,
  setuptools-scm,
  axisregistry,
  absl-py,
  glyphslib,
  gflanguages,
  gfsubsets,
  glyphsets,
  pygithub,
  pillow,
  protobuf,
  requests,
  tabulate,
  unidecode,
  ots-python,
  vttlib,
  pygit2,
  strictyaml,
  skia-pathops,
  statmake,
  pyyaml,
  babelfont,
  ttfautohint-py,
  brotli,
  jinja2,
  fontfeatures,
  vharfbuzz,
  bumpfontversion,
  nanoemoji,
  font-v,
  beautifulsoup4,
  rich,
  packaging,
  ninja,
  networkx,
  ruamel-yaml,
  ufomerge,
  fontbakery,
  diffenator2,
  pycairo,
  coreutils,
  fonttools,
  fontmake,
  afdko,
  paintcompiler,
  harfbuzz,
  opentype-feature-freezer,
}:

buildPythonPackage rec {
  pname = "gftools";
  version = "0.9.63";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "gftools";
    rev = "v${version}";
    hash = "sha256-A9SOpD9OEZYPO9PhbpmNJ1qr2DxqIjIx9bo7s+9lllg=";
  };

  postPatch = ''
    substituteInPlace \
      Lib/gftools/builder/operations/{buildTTF,glyphs2ds,buildVariable,buildOTF}.py \
      --replace-fail '"fontmake' '"${lib.getExe' fontmake "fontmake"}'

    substituteInPlace \
      Lib/gftools/builder/operations/instantiateUfo.py \
      --replace-fail "'fontmake" "'${lib.getExe' fontmake "fontmake"}"

    substituteInPlace \
      Lib/gftools/builder/operations/{compress,subspace}.py \
      --replace-fail '"fonttools' '"${lib.getExe' fonttools "fonttools"}'

    substituteInPlace \
      Lib/gftools/builder/operations/hbsubset.py \
      --replace-fail '"pyftsubset"' '"${lib.getExe' fonttools "pyftsubset"}"' \
      --replace-fail '"hb-subset"' '"${lib.getExe' harfbuzz "hb-subset"}"'

    substituteInPlace \
      Lib/gftools/builder/operations/autohintOTF.py \
      --replace-fail '"otfautohint' '"${lib.getExe' afdko "otfautohint"}'

    substituteInPlace \
      Lib/gftools/builder/operations/paintcompiler.py \
      --replace-fail '"paintcompiler' '"${lib.getExe paintcompiler}'

    substituteInPlace \
      Lib/gftools/builder/operations/featureFreeze.py \
      --replace-fail '"pyftfeatfreeze' '"${lib.getExe opentype-feature-freezer}'

    substituteInPlace \
      Lib/gftools/builder/operations/copy.py \
      --replace-fail '"cp' '"${lib.getExe' coreutils "cp"}'

    substituteInPlace \
      Lib/gftools/builder/operations/{fix,remap,autohint,buildStat,addSubset,remapLayout,buildVTT}.py \
      --replace-fail '"gftools' '"${placeholder "out"}/bin/gftools'

    substituteInPlace \
      Lib/gftools/builder/operations/rename.py \
      --replace-fail "'gftools" "'${placeholder "out"}t/bin/gftools"
  '';

  pythonRelaxDeps = [ "protobuf" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    absl-py
    afdko
    axisregistry
    babelfont
    beautifulsoup4
    brotli
    bumpfontversion
    font-v
    fontfeatures
    fontmake
    fonttools
    gflanguages
    gfsubsets
    glyphsets
    glyphslib
    jinja2
    nanoemoji
    networkx
    ninja
    ots-python
    packaging
    pillow
    protobuf
    pygit2
    pygithub
    pyyaml
    requests
    rich
    ruamel-yaml
    setuptools
    skia-pathops
    statmake
    strictyaml
    tabulate
    ttfautohint-py
    ufomerge
    unidecode
    vharfbuzz
    vttlib
  ];

  optional-dependencies = {
    qa = [
      fontbakery
      diffenator2
      pycairo
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    black
  ];

  disabledTestPaths = [
    # Wants non exsiting module
    "bin/test_args.py"
    # Requires internet
    "tests/push/test_items.py"
    "tests/test_gfgithub.py"
    "tests/test_usage.py"
    "tests/push/test_servers.py"
    # Can't find directory
    "tests/test_builder.py"
    "tests/test_dependencies.py"
    "tests/test_fix.py"
    "tests/test_tags.py"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Misc tools for working with the Google Fonts library";
    homepage = "https://github.com/googlefonts/gftools";
    license = licenses.asl20;
    mainProgram = "gftools";
    maintainers = with maintainers; [ jopejoe1 ];
  };
}
