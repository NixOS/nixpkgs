venvShellHook() {
    echo "Executing venvHook"
    runHook preShellHook

    if [ -d "${venvDir}" ]; then
      echo "Skipping venv creation, '${venvDir}' already exists"
      source "${venvDir}/bin/activate"
    else
      echo "Creating new venv environment in path: '${venvDir}'"
      @pythonInterpreter@ -m venv "${venvDir}"

      source "${venvDir}/bin/activate"
      runHook postVenvCreation
    fi

    runHook postShellHook
    echo "Finished executing venvShellHook"
}

if [ -z "${dontUseVenvShellHook:-}" ] && [ -z "${shellHook-}" ]; then
    echo "Using venvShellHook"
    if [ -z "${venvDir-}" ]; then
        echo "Error: \`venvDir\` should be set when using \`venvShellHook\`."
        exit 1
    else
        shellHook=venvShellHook
    fi
fi
