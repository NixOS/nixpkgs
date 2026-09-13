{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  duckdb,
  clingo,
  ipython,
  pandas,
}:

buildPythonPackage (finalAttrs: {
  pname = "logica";
  # Build from main, as the last official release
  # 1.3.1415926535897 is 10 months and 146 commits behind
  version = "1.3.1415926535897-unstable-2026-05-16";
  pyproject = true;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "EvgSkv";
    repo = "logica";
    rev = "a4739db9fd9912c2b0d61f7fba1b692acc2fa59c";
    hash = "sha256-dsmFyO7eC9gRY9vBShOpTtweMPgORiYU3MKERanQkN0=";
  };

  # The repo is not buildable by default. Copy the steps in the repo's
  # .github/scripts/deploy.sh
  postPatch = ''
    mkdir .package # Avoid clash with executable named "logica"
    mv * .github .gitignore .package
    mv .package logica
    cp logica/.github/scripts/setup.py .
    cp logica/.github/scripts/__main__.py logica/

    # Only sqlite and duckdb queries can run in the sandbox
    substituteInPlace logica/common/logica_test.py --replace-fail \
      '  """Run one test."""' \
      '  """Run one test."""
      if any(f"@Engine(\"{engine}\")" in open(src).read()
             for engine in ["bigquery", "psql"]):
        return'

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace logica/integration_tests/sqlite_file_test.l --replace-fail \
        '/tmp/sqlite_file_test_data.txt' \
        'sqlite_file_test_data.txt'
    ''}
  '';

  build-system = [ setuptools ];

  dependencies = [ duckdb ];

  nativeCheckInputs = [
    clingo
    ipython
    pandas
  ];

  # Upstream's runner always exits 0, so failures are detected by
  # grepping its golden-comparison output.
  checkPhase = ''
    runHook preCheck
    (
      cd logica
      python run_all_tests.py 2>&1 | tee test.log
      test "''${PIPESTATUS[0]}" -eq 0
      grep -q PASSED test.log
      ! grep -q FAILED test.log
    )
    runHook postCheck
  '';

  pythonImportsCheck = [ "logica" ];

  meta = {
    description = "Declarative logic programming language for data manipulation";
    homepage = "https://logica.dev/";
    license = [ lib.licenses.asl20 ];
    mainProgram = "logica";
    maintainers = [ lib.maintainers.rskew ];
  };
})
