venvShellHook() {
    echo "Executing venvHook"
    runHook preShellHook

    if [ -d "${venvDir}" ]; then
      echo "Skipping venv creation, '${venvDir}' already exists"
    else
      echo "Creating new venv environment in path: '${venvDir}'"
      @pythonInterpreter@ -m venv "${venvDir}"
    fi

    source "${venvDir}/bin/activate"

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
