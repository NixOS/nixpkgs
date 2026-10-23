yarnBerryConfigHook() {
    echo "Executing yarnBerryConfigHook"

    # Use a constant HOME directory
    export HOME=$(mktemp -d)
    if [[ -n "$yarnOfflineCache" ]]; then
        offlineCache="$yarnOfflineCache"
    fi
    if [[ -z "$offlineCache" ]]; then
        echo yarnBerryConfigHook: No yarnOfflineCache or offlineCache were defined\! >&2
        exit 2
    fi

    local -r cacheLockfile="$offlineCache/yarn.lock"
    local -r srcLockfile="$PWD/yarn.lock"

    echo "Validating consistency between $srcLockfile and $cacheLockfile"

    if ! @diff@ "$srcLockfile" "$cacheLockfile"; then
      # If the diff failed, first double-check that the file exists, so we can
      # give a friendlier error msg.
      if ! [ -e "$srcLockfile" ]; then
        echo
        echo "ERROR: Missing yarn.lock from src. Expected to find it at: $srcLockfile"
        echo "Hint: You can copy a vendored yarn.lock file via postPatch."
        echo

        exit 1
      fi

      if ! [ -e "$cacheLockfile" ]; then
        echo
        echo "ERROR: Missing lockfile from cache. Expected to find it at: $cacheLockfile"
        echo

        exit 1
      fi

      echo
      echo "ERROR: fetchYarnDeps hash is out of date"
      echo
      echo "The yarn.lock in src is not the same as the in $offlineCache."
      echo
      echo "To fix the issue:"
      echo '1. Use `lib.fakeHash` as the fetchYarnBerryDeps hash value'
      echo "2. Build the derivation and wait for it to fail with a hash mismatch"
      echo "3. Copy the 'got: sha256-' value back into the fetchYarnBerryDeps hash field"
      echo

      exit 1
    fi

    if [[ -n "$missingHashes" ]] || [[ -f "$offlineCache/missing-hashes.json" ]]; then
      echo "Validating consistency of missing-hashes.json"
      if [[ -z "$missingHashes" ]]; then
        echo "You must specify missingHashes in your derivation"
        exit 1
      fi
      if ! @diff@ "$missingHashes" "$offlineCache/missing-hashes.json"; then
        exit 1
      fi
    fi

    YARN_IGNORE_PATH=1 @yarn_offline@ config set enableTelemetry false
    YARN_IGNORE_PATH=1 @yarn_offline@ config set enableGlobalCache false

    # The cache needs to be writable in case yarn needs to re-pack any patch: or git dependencies
    rm -rf ./.yarn/cache
    mkdir -p ./.yarn
    cp -r --reflink=auto $offlineCache/cache ./.yarn/cache
    chmod u+w -R ./.yarn/cache
    [ -d $offlineCache/checkouts ] && cp -r --reflink=auto $offlineCache/checkouts ./.yarn/checkouts
    [ -d $offlineCache/checkouts ] && chmod u+w -R ./.yarn/checkouts

    export npm_config_nodedir="@nodeSrc@"
    export npm_config_node_gyp="@nodeGyp@"

    YARN_IGNORE_PATH=1 @yarn_offline@ install --mode=skip-build --inline-builds
    if [[ -z "${dontYarnBerryPatchShebangs-}" ]]; then
      echo "Running patchShebangs in between the Link and the Build step..."
      patchShebangs node_modules
    fi
    if ! [[ "$YARN_ENABLE_SCRIPTS" == "0" || "$YARN_ENABLE_SCRIPTS" == "false" ]]; then
      YARN_IGNORE_PATH=1 @yarn_offline@ install --inline-builds
    fi

    echo "finished yarnBerryConfigHook"
}

if [[ -z "${dontYarnBerryInstallDeps-}" ]]; then
    postConfigureHooks+=(yarnBerryConfigHook)
fi
