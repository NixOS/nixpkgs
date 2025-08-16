_handleCmdOutput(){
    local versionOutput

    local envArgs=()
    if [[ "$1" != "*" ]]; then
      envArgs+=("--ignore-environment")
      for var in $1; do
        envArgs+=("$var=${!var}")
      done
    fi

    shift 1
    local command=("$@")

    versionOutput="$(env \
        --chdir=/ \
        --argv0="$(basename "${command[0]}")" \
        "${envArgs[@]}" \
        "${command[@]}" 2>&1 \
        | sed -e 's|@storeDir@/[^/ ]*/|{{storeDir}}/|g' \
        || true)"
    if [[ "$versionOutput" =~ "$version" ]]; then
        echoPrefix="Successfully managed to"
    else
        echoPrefix="Did not"
    fi
    # The return value of this function is this variable:
    echo "$echoPrefix"
    # And in anycase we want these to be printed in the build log, useful for
    # debugging, so we print these to stderr.
    echo "$echoPrefix" find version "$version" in the output of the command \
        "${command[@]}" >&2
    echo "$versionOutput" >&2
}
versionCheckHook(){
    runHook preVersionCheck
    echo Executing versionCheckPhase

    # Don't keep any environment variables by default
    : "${versionCheckKeepEnvironment:=}"

    local echoPrefix

    if [[ -n "${versionCheckScript-}" ]]; then
      echoPrefix="$(_handleCmdOutput "$versionCheckKeepEnvironment" "@bash@" "-c" "$versionCheckScript")"
    else
      local cmdProgram cmdArg
      if [[ ! -z "${versionCheckProgram-}" ]]; then
          cmdProgram="$versionCheckProgram"
      elif [[ ! -z "${NIX_MAIN_PROGRAM-}" ]]; then
          cmdProgram="${!outputBin}/bin/${NIX_MAIN_PROGRAM}"
      elif [[ ! -z "${pname-}" ]]; then
          echo "versionCheckHook: Package \`${pname}\` does not have the \`meta.mainProgram\` attribute." \
              "We'll assume that the main program has the same name for now, but this behavior is deprecated," \
              "because it leads to surprising errors when the assumption does not hold." \
              "If the package has a main program, please set \`meta.mainProgram\` in its definition to make this warning go away." \
              "Should the binary that outputs the intended version differ from \`meta.mainProgram\`, consider setting \`versionCheckProgram\` instead." >&2
          cmdProgram="${!outputBin}/bin/${pname}"
      else
          echo "versionCheckHook: \$NIX_MAIN_PROGRAM, \$versionCheckProgram and \$pname are all empty, so" \
              "we don't know how to run the versionCheckPhase." \
              "To fix this, set one of \`meta.mainProgram\` or \`versionCheckProgram\`." >&2
          exit 2
      fi

      if [[ ! -x "$cmdProgram" ]]; then
          echo "versionCheckHook: $cmdProgram was not found, or is not an executable" >&2
          exit 2
      fi
      if [[ -z "${versionCheckProgramArg}" ]]; then
          for cmdArg in "--help" "--version"; do
              echoPrefix="$(_handleCmdOutput "$versionCheckKeepEnvironment" "$cmdProgram" "$cmdArg")"
              if [[ "$echoPrefix" == "Successfully managed to" ]]; then
                  break
              fi
          done
      else
          cmdArg="$versionCheckProgramArg"
          echoPrefix="$(_handleCmdOutput "$versionCheckKeepEnvironment" "$cmdProgram" "$cmdArg")"
      fi
    fi
    if [[ "$echoPrefix" == "Did not" ]]; then
        exit 2
    fi

    runHook postVersionCheck
    echo Finished versionCheckPhase
}

if [[ -z "${dontVersionCheck-}" ]]; then
    echo "Using versionCheckHook"
    preInstallCheckHooks+=(versionCheckHook)
fi
