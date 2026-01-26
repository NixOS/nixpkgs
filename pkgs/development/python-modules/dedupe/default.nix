{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  affinegap,
  btrees,
  categorical-distance,
  dedupe-levenshtein-search,
  doublemetaphone,
  haversine,
  highered,
  numpy,
  scikit-learn,
  simplecosine,
  zope-index,
  dedupe,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
  python,
  runCommand,
}:

buildPythonPackage rec {
  pname = "dedupe";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "dedupe";
    tag = "v${version}";
    hash = "sha256-tfBJeaeZw5w5OwM+AOfy9H6P2zbShjN/kuzEbpxATHI=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    affinegap
    btrees
    categorical-distance
    dedupe-levenshtein-search
    doublemetaphone
    haversine
    highered
    numpy
    scikit-learn
    simplecosine
    zope-index
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  # Remove source directory so pytest imports compiled extension from $out
  preCheck = ''
    rm -rf dedupe
  '';

  pythonImportsCheck = [
    "dedupe"
  ];

  passthru.tests.benchmarks =
    runCommand "dedupe-benchmarks-test"
      {
        nativeBuildInputs = [ (python.withPackages (ps: [ dedupe ])) ];
      }
      ''
        # Copy benchmarks to writable location
        cp -r ${src}/benchmarks benchmarks
        chmod -R +w benchmarks
        cd benchmarks

        # Run all three canonical benchmarks
        for benchmark in canonical canonical_gazetteer canonical_matching; do
          echo "Running $benchmark benchmark..."
          # Redirect stderr to /dev/null (`2>/dev/null`) to suppress Python 3.13
          # multiprocessing resource tracker warnings from scikit-learn/joblib subprocesses
          # `|| exit 1` provides fail-fast behavior: exit immediately if any benchmark fails
          PYTHONPATH=$PWD python -m benchmarks.$benchmark 2>/dev/null || exit 1
        done

        touch $out
      '';

  meta = {
    description = "Library for accurate and scalable fuzzy matching, deduplication and entity resolution";
    homepage = "https://github.com/dedupeio/dedupe";
    changelog = "https://github.com/dedupeio/dedupe/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
