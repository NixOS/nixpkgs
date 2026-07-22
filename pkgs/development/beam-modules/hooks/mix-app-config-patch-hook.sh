# shellcheck shell=bash
#
# We don't want to include whatever config a dependency brings; per
# https://hexdocs.pm/elixir/main/Config.html, config is application specific.

mixAppConfigPatchHook() {
  echo "Executing mixAppConfigPatchHook"

  rm -rvf config

  # But we still need a way to provide config for deps that need compile time config
  if [ ! -z "${appConfigPath}" ]; then
    ln -sf "${appConfigPath}" config
  fi

  echo "Finished mixAppConfigPatchHook"
}

prePatchHooks+=(mixAppConfigPatchHook)
