# shellcheck shell=bash
#
# Symlink dependency sources. This is needed for projects that require
# access to the source of their dependencies. For example, Phoenix
# projects need javascript assets to build asset bundles.

mixNixDepsPostConfigure() {
  echo "Executing mixNixDepsPostConfigure"

  local name
  for name in "${!mixNixDeps[@]}"; do
    if [ -d "${mixNixDeps[$name]}/src" ]; then
      mkdir -p deps
      ln -sv "${mixNixDeps[$name]}/src" "deps/$name"
    fi
  done

  echo "Finished mixNixDepsPostConfigure"
}

postConfigureHooks+=(mixNixDepsPostConfigure)
