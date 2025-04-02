{ pkgs, lib, buildNpmPackage, terminusdb, procps }:

buildNpmPackage {
  pname = "terminusdb-tests";
  inherit (terminusdb) src version;

  nativeBuildInputs = [ terminusdb procps ];

  sourceRoot = "${terminusdb.src.name}/tests";

  npmDepsHash = "sha256-NPrslLiCw5STAgnFE8mNEh7TYd68Z6L+4YnPQOqG2TQ=";

  postPatch = ''
    # Use `terminusdb` from PATH instead of './terminusdb.sh' wrapper script
    find . -type f -iname "*.js" -exec sed -i 's|./terminusdb.sh|terminusdb|g' {} \;
    # Read git hash from the COMMIT file made during package derivation
    sed -i "s|\
    const { stdout: result } = await exec('git rev-parse --verify HEAD')|\
    const result = await fs.readFile('${terminusdb.src}/COMMIT', 'utf8')|\
    " lib/info.js
    # Remove the unused `exec` variable for ESLint
    sed -i "/const exec = require('util').promisify(require('child_process').exec)/d" lib/info.js
  '';

  dontNpmBuild = true;
  doCheck = true;

  preCheck = ''
    # Ensure proper handling of UTF-8 encoded characters in command outputs and logs
    export LANG="C.UTF-8"
    export LC_ALL="C.UTF-8"
    # Initialise the server
    terminusdb store init --force
    # Start the server in the background and save its PID
    terminusdb serve &
    TERMINUSDB_PID=$!
    echo "TerminusDB PID: $TERMINUSDB_PID"
    # Give the server enough time to start
    sleep 5
  '';

  checkPhase = ''
    runHook preCheck
    npm test
    runHook postCheck
  '';

  # Ensure the server is properly stopped after tests
  postCheck = ''
    kill $TERMINUSDB_PID
  '';

  installPhase = ''
    touch $out
  '';

}
