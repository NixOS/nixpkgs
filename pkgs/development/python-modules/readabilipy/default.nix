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

  javascript = buildNpmPackage {
    pname = "readabilipy-javascript";
    inherit version;

    src = src;
    sourceRoot = "${src.name}/readabilipy/javascript";
    npmDepsHash = "sha256-LiPSCZamkJjivzpawG7H9IEXYjn3uzFeY2vfucyHfUo=";

    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';

    dontNpmBuild = true;
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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

  passthru = {
    tests.version = testers.testVersion {
      package = readabilipy;
      command = "readabilipy --version";
      version = "${version} (Readability.js supported: yes)";
    };
  };

  meta = with lib; {
    description = "HTML content extractor";
    mainProgram = "readabilipy";
    homepage = "https://github.com/alan-turing-institute/ReadabiliPy";
    changelog = "https://github.com/alan-turing-institute/ReadabiliPy/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
