{
  lib,
  buildNpmPackage,
  fetchpatch2,
  terminusdb,
  procps,
  curl,
}:

buildNpmPackage {
  pname = "terminusdb-tests";
  inherit (terminusdb) src version;

  nativeCheckInputs = [
    terminusdb
    procps
    curl
  ];

  sourceRoot = "${terminusdb.src.name}/tests";

  npmDepsHash = "sha256-R2kbwHhlja5mH2AGpyiiVCz3YmSWF9cWptOTdcZb0PM=";

  # Test-only JS adjustments live here so the runtime package stays untouched
  postPatch = ''
    # Read git hash from the COMMIT file in the source
    substituteInPlace lib/info.js --replace-fail \
      "  const { stdout: result } = await exec('git rev-parse --verify HEAD')" \
      "  const result = await fs.readFile('${terminusdb.src}/COMMIT', 'utf8')"

    patchShebangs terminusdb.sh
  '';

  dontNpmBuild = true;
  doCheck = true;

  # Custom test harness
  preCheck = ''
    # Test server endpoint and startup timeout
    TERMINUSDB_INFO_URL="http://localhost:6363/api/info"
    TERMINUSDB_START_TIMEOUT=60

    note() { echo "$@"; }
    fail() { echo "ERROR: $*" >&2; return 1; }

    stop_terminusdb() {
      [ -n "''${TERMINUSDB_PID:-}" ] || fail "missing TERMINUSDB_PID"
      kill "$TERMINUSDB_PID"
      wait "$TERMINUSDB_PID" || true
      unset TERMINUSDB_PID
    }

    wait_for_terminusdb() {
      curl --fail --silent \
        --max-time 2 \
        --retry "$TERMINUSDB_START_TIMEOUT" \
        --retry-delay 1 \
        --retry-all-errors \
        --retry-max-time "$TERMINUSDB_START_TIMEOUT" \
        "$TERMINUSDB_INFO_URL" >/dev/null \
        || fail "TerminusDB failed to start within ''${TERMINUSDB_START_TIMEOUT} seconds"
    }

    start_terminusdb() {
      # Initialise the server
      terminusdb store init --force

      # Start the server in the background
      terminusdb serve & TERMINUSDB_PID=$!
      note "TerminusDB PID: $TERMINUSDB_PID"

      # Wait for server with custom timeout handling
      note "Waiting for TerminusDB to start..."
      wait_for_terminusdb
      note "TerminusDB is ready!"
    }

    # Ensure the server is stopped even if tests fail
    trap 'runHook postCheck' EXIT

    # Ensure proper handling of UTF-8 encoded characters in command outputs and logs
    export LANG="C.UTF-8" LC_ALL="C.UTF-8"

    # Keep logs quiet during tests
    export TERMINUSDB_LOG_LEVEL="ERROR"

    # Point test helpers at the packaged terminusdb binary
    export TERMINUSDB_EXEC_PATH="${lib.getExe terminusdb}"

    start_terminusdb
  '';

  checkPhase = ''
    runHook preCheck

    note "Running local tests..."; npm run test-local
    note "Running served tests..."; npm run test-served

    runHook postCheck
  '';

  # Ensure the server is properly stopped after tests
  postCheck = ''
    # Disable the EXIT trap so cleanup only runs once
    trap - EXIT
    stop_terminusdb
  '';

  installPhase = ''
    touch $out
  '';

}
