# shellcheck shell=bash

# Setup hook for fixing Python shebangs
# Many python packages have shell scripts which end up using the pythonOnBuildForHost interpreter.
# This shell hook goes through the outputs and changes it from the pythonOnBuildForHost to python built for the target platform.
echo "Sourcing python-shebangs-fixup-hook.sh"

pythonFixShebangs() {
    local output="$1"

    for path in $(@gnugrep@/bin/grep -l -r '#!@pythonOnBuildForHost@' "$output"); do
      sed -i 's|@pythonOnBuildForHost@|@python@|g' "$path"
    done
}

pythonShebangsFixupPhase() {
    echo "Executing pythonShebangsFixupHook"

    for output in $(getAllOutputNames); do pythonFixShebangs "$output" done

    echo "Finished executing pythonShebangsFixupHook"
}

if [[ -z "${dontFixupPythonShebangs-}" ]]; then
    postFixupHooks+=(pythonShebangsFixupPhase)
fi
