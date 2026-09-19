# shellcheck shell=bash

mixEscriptBuild() {
  echo "Executing mixEscriptBuild"

  mix escript.build --no-deps-check

  echo "Finished mixEscriptBuild"
}

mixEscriptInstall() {
  echo "Executing mixEscriptInstall"

  runHook preInstall

  mkdir -p "$out/bin"
  cp "$escriptBinName" "$out/bin"

  runHook postInstall

  echo "Finished mixEscriptInstall"
}

postBuildHooks+=(mixEscriptBuild)

if [ -z "${dontMixEscriptInstall-}" ] && [ -z "${installPhase-}" ]; then
  installPhase=mixEscriptInstall
fi
