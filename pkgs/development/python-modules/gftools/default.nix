{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  absl-py,
  afdko,
  axisregistry,
  babelfont,
  beautifulsoup4,
  black,
  brotli,
  bumpfontversion,
  coreutils,
  diffenator2,
  ffmpeg-python,
  font-v,
  fontbakery,
  fontfeatures,
  fontmake,
  fonttools,
  gflanguages,
  gfsubsets,
  glyphsets,
  glyphslib,
  harfbuzz,
  jinja2,
  nanoemoji,
  networkx,
  ninja,
  opentype-feature-freezer,
  ots-python,
  packaging,
  paintcompiler,
  pillow,
  protobuf,
  pycairo,
  pygit2,
  pygithub,
  pytest,
  pyyaml,
  requests,
  rich,
  ruamel-yaml,
  skia-pathops,
  statmake,
  strictyaml,
  tabulate,
  ttfautohint-py,
  ufomerge,
  unidecode,
  vharfbuzz,
  vttlib,
  python,
}:

let
  fontmake' = python.withPackages (ps: [ ps.fontmake ] ++ ps.fontmake.optional-dependencies.json);
  fonttools' = python.withPackages (ps: [ ps.fonttools ] ++ ps.fonttools.optional-dependencies.ufo);
in
buildPythonPackage rec {
  pname = "gftools";
  version = "0.9.91";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "gftools";
    tag = "v${version}";
    hash = "sha256-tIvOHBA7MiNYrl9ZmfieSF+QwhM30pwle1mHVZamDo0=";
  };

  postPatch = ''
    substituteInPlace \
      Lib/gftools/builder/operations/{buildTTF,glyphs2ds,buildVariable,buildOTF}.py \
      --replace-fail '"fontmake' '"${lib.getExe' fontmake' "fontmake"}'

    substituteInPlace \
      Lib/gftools/builder/operations/instantiateUfo.py \
      --replace-fail "'fontmake" "'${lib.getExe' fontmake' "fontmake"}"

    substituteInPlace \
      Lib/gftools/builder/operations/{compress,subspace}.py \
      --replace-fail '"fonttools' '"${lib.getExe' fonttools' "fonttools"}'

    substituteInPlace \
      Lib/gftools/builder/operations/hbsubset.py \
      --replace-fail '"pyftsubset"' '"${lib.getExe' fonttools' "pyftsubset"}"' \
      --replace-fail '"hb-subset"' '"${lib.getExe' harfbuzz "hb-subset"}"'

    substituteInPlace \
      Lib/gftools/builder/operations/autohintOTF.py \
      --replace-fail 'otfautohint' '${lib.getExe' afdko "otfautohint"}'

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
      Lib/gftools/builder/operations/{fix,remap,autohint,buildStat,addSubset,remapLayout,buildVTT,buildAvar2}.py \
      --replace-fail '"gftools' '"${placeholder "out"}/bin/gftools'

    substituteInPlace \
      Lib/gftools/builder/operations/rename.py \
      --replace-fail "'gftools" "'${placeholder "out"}t/bin/gftools"
  '';

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  pythonRelaxDeps = [
    "protobuf"
    "pygit2"
  ];

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
    ffmpeg-python
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
  ]
  ++ fonttools.optional-dependencies.ufo
  ++ fontmake.optional-dependencies.json;

  optional-dependencies = {
    qa = [
      diffenator2
      fontbakery
      pycairo
    ];
    test = [
      black
      pytest
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Wants none existing module
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
  ];

  pythonImportsCheck = [ "gftools" ];

  meta = with lib; {
    description = "Misc tools for working with the Google Fonts library";
    homepage = "https://github.com/googlefonts/gftools";
    changelog = "https://github.com/googlefonts/gftools/releases/tag/${src.tag}";
    license = licenses.asl20;
    mainProgram = "gftools";
    maintainers = with maintainers; [ jopejoe1 ];
  };
}
