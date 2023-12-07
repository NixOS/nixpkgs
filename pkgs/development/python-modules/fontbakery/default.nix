{ lib
, buildPythonPackage
, callPackage
, fetchpatch
, fetchPypi
, axisregistry
, babelfont
, beautifulsoup4
, beziers
, cmarkgfm
, collidoscope
, defcon
, dehinter
, fonttools
, font-v
, freetype-py
, gflanguages
, git
, glyphsets
, lxml
, installShellFiles
, munkres
, opentypespec
, ots-python
, packaging
, pip-api
, protobuf
, pytestCheckHook
, pytest-xdist
, pythonRelaxDepsHook
, pyyaml
, requests
, requests-mock
, rich
, setuptools-scm
, shaperglot
, stringbrewer
, toml
, unicodedata2
, ufo2ft
, ufolint
, vharfbuzz
}:

buildPythonPackage rec {
  pname = "fontbakery";
  version = "0.10.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ye/TMGvURxSU2yoohwYbSo5RvrmbHKdMnFNj2lUvtMk=";
  };

  patches = [
    # Mock HTTP requests in tests (note we still have to skip some below)
    # https://github.com/googlefonts/fontbakery/pull/4124
    (fetchpatch {
      url = "https://github.com/fonttools/fontbakery/pull/4124.patch";
      hash = "sha256-NXuC2+TtxpHYMdd0t+cF0FJ3lrh4exP5yxspEasKKd0=";
    })
  ];

  propagatedBuildInputs = [
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
    glyphsets
    lxml
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
  nativeBuildInputs = [
    installShellFiles
    pythonRelaxDepsHook
    setuptools-scm
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
    "test_check_vertical_metrics_regressions"
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

