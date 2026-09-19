# shellcheck shell=bash
#
# This is needed for projects that have a specific compile step
# the dependency needs to be compiled in order for the task
# to be available.
#
# Phoenix projects for example will need compile.phoenix.

mixDepsCompileHook() {
  echo "Executing mixDepsCompileHook"

  mix deps.compile --no-deps-check --skip-umbrella-children

  echo "Finished mixDepsCompileHook"
}

postConfigureHooks+=(mixDepsCompileHook)
