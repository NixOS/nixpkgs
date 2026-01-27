# shellcheck shell=bash
mixCompileHook() {
  echo "Executing mixCompileHook"

  runHook preBuild

  local flagsArray=()
  concatTo flagsArray compileFlags

  mix compile --no-deps-check "${flagsArray[@]}"

  runHook postBuild

  echo "Finished mixCompileHook"
}

if [ -z "${dontMixCompile-}" ] && [ -z "${buildPhase-}" ]; then
  buildPhase=mixCompileHook
fi
