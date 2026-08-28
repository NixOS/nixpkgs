# shellcheck shell=bash

mixReleaseInstallHook() {
  echo "Executing mixReleaseInstallHook"

  runHook preInstall

  mix release ${mixReleaseName:+"$mixReleaseName"} --no-deps-check --path "$out"

  runHook postInstall

  echo "Finished mixReleaseInstallHook"
}

if [ -z "${dontMixReleaseInstall-}" ] && [ -z "${installPhase-}" ]; then
  installPhase=mixReleaseInstallHook
fi
