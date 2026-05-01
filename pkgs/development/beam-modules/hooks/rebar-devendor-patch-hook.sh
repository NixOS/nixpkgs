# shellcheck shell=bash
#
# It's common to vendor a copy of rebar/rebar3 in repos, but we want to remove those

rebarDevendorPatchHook() {
  echo "Executing rebarDevendorPatchHook"

  rm -f rebar rebar

  echo "Finished rebarDevendorPatchHook"
}

prePatchHooks+=(rebarDevendorPatchHook)
