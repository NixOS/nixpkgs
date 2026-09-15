# shellcheck shell=bash

mixReleaseInstallHook() {
  echo "Executing mixReleaseInstallHook"

  runHook preInstall

  mix release ${mixReleaseName:+"$mixReleaseName"} --no-deps-check --path "$out"

  runHook postInstall

  echo "Finished mixReleaseInstallHook"
}

mixReleaseFixupHook() {
  echo "Executing mixReleaseFixupHook"

  echo "Removing files for Microsoft Windows"
  rm -f "$out"/bin/*.bat

  echo "Wrapping programs in $out/bin with their runtime deps"
  find "$out/bin/" -type f -executable | while read f; do
    wrapProgram "$f" --prefix PATH : "$mixReleaseRuntimePath"
  done

  # shellcheck disable=SC2144 # this will only work for a single erts
  if [ -e "$out"/erts-* ]; then
    mixReleaseRemoveErlangReferences
  fi

  echo "Finished mixReleaseFixupHook"
}

mixReleaseRemoveErlangReferences() {
  # ERTS is included in the release, then erlang is not required as a runtime dependency.
  # But, erlang is still referenced in some places. To removed references to erlang,
  # following steps are required.

  echo "Removing references to erlang"

  # 1. remove references to erlang from plain text files
  for file in $(rg "${erlang}/lib/erlang" "$out" --files-with-matches); do
    substituteInPlace "$file" --replace "${erlang}/lib/erlang" "$out"
  done

  # 2. remove references to erlang from .beam files
  #
  # No need to do anything, because it has been handled by "deterministic" option specified
  # by ERL_COMPILER_OPTIONS.

  # 3. remove references to erlang from normal binary files
  for file in $(rg "${erlang}/lib/erlang" "$out" --files-with-matches --binary --iglob '!*.beam'); do
    echo "removing references to erlang in $file"
    # use bbe to substitute strings in binary files, because using substituteInPlace
    # on binaries will raise errors
    bbe -e "s|${erlang}/lib/erlang|$out|" -o "$file".tmp "$file"
    rm -f "$file"
    mv "$file".tmp "$file"
  done

  # References to erlang should be removed from output after above processing.
}

mixReleaseRemoveCookieHook() {
  if [ -e "$out/releases/COOKIE" ]; then
    echo "Removing $out/releases/COOKIE"
    rm "$out/releases/COOKIE"
  fi
}

mixReleaseStripDebugHook() {
  # Strip debug symbols to avoid hardreferences to "foreign" closures actually
  # not needed at runtime, while at the same time reduce size of BEAM files.
  erl -noinput -eval 'lists:foreach(fun(F) -> io:format("Stripping ~p.~n", [F]), beam_lib:strip(F) end, filelib:wildcard("'"$out"'/**/*.beam"))' -s init stop
}

if [ -z "${dontMixReleaseFixup-}" ]; then
  preFixupHooks+=(mixReleaseFixupHook)
fi

if [ -n "${removeCookie-1}" ]; then
  preFixupHooks+=(mixReleaseRemoveCookieHook)
fi

if [ -n "${stripDebug-}" ]; then
  postFixupHooks+=(mixReleaseStripDebugHook)
fi

if [ -z "${dontMixReleaseInstall-}" ] && [ -z "${installPhase-}" ]; then
  installPhase=mixReleaseInstallHook
fi
