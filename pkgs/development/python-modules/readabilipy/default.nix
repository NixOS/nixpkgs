{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  buildNpmPackage,
  fetchFromGitHub,
  html5lib,
  lxml,
  nodejs,
  pytestCheckHook,
  pythonOlder,
  regex,
  setuptools,
  testers,
  readabilipy,
}:

buildPythonPackage rec {
  pname = "readabilipy";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alan-turing-institute";
    repo = "ReadabiliPy";
    tag = "v${version}";
    hash = "sha256-FYdSbq3rm6fBHm5fDRAB0airX9fNcUGs1wHN4i6mnG0=";
  };

  patches = [
    # Fix test failures with Python 3.13.6
    # https://github.com/alan-turing-institute/ReadabiliPy/pull/116
    ./python3.13.6-compatibility.patch
  ];

  javascript = buildNpmPackage {
    pname = "readabilipy-javascript";
    inherit version;

    src = src;
    sourceRoot = "${src.name}/readabilipy/javascript";
    npmDepsHash = "sha256-1yp80TwRbE/NcMa0qrml0TlSZJ6zwSTmj+zDjBejko8=";

    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';

    dontNpmBuild = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    html5lib
    lxml
    regex
  ];

  postPatch = ''
    ln -s $javascript/lib/node_modules/ReadabiliPy/node_modules readabilipy/javascript/node_modules
    echo "recursive-include readabilipy/javascript *" >MANIFEST.in
  '';

  postInstall = ''
    wrapProgram $out/bin/readabilipy \
      --prefix PATH : ${nodejs}/bin
  '';

  nativeCheckInputs = [
    pytestCheckHook
    nodejs
  ];

  pythonImportsCheck = [ "readabilipy" ];

  disabledTestPaths = [
    # Exclude benchmarks
    "tests/test_benchmarking.py"
  ];

  disabledTests = [
    # IndexError: list index out of range
    "test_html_blacklist"
    "test_prune_div_with_one_empty_span"
    "test_prune_div_with_one_whitespace_paragraph"
    "test_empty_page"
    "test_contentless_page"
    "test_extract_title"
    "test_iframe_containing_tags"
    "test_iframe_with_source"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = readabilipy;
      command = "readabilipy --version";
      version = "${version} (Readability.js supported: yes)";
    };
  };

  meta = with lib; {
    description = "HTML content extractor";
    homepage = "https://github.com/alan-turing-institute/ReadabiliPy";
    changelog = "https://github.com/alan-turing-institute/ReadabiliPy/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "readabilipy";
  };
}
