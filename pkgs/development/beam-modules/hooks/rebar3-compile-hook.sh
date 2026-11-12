# shellcheck shell=bash

rebar3CompileHook() {
  echo "Executing rebar3CompileHook"

  runHook preBuild

  HOME=. rebar3 bare compile --paths "."

  runHook postBuild

  echo "Finished rebar3CompileHook"
}

if [ -z "${dontRebar3Compile-}" ] && [ -z "${buildPhase-}" ]; then
  buildPhase=rebar3CompileHook
fi
