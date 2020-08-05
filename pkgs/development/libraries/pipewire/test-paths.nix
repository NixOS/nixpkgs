{ lib, runCommand, pipewire, paths-out, paths-lib }:

runCommand "pipewire-test-paths" { } ''
  ${lib.concatMapStringsSep "\n" (p: ''
    if [ ! -f "${pipewire.lib}/${p}" ] && [ ! -d "${pipewire.lib}/${p}" ]; then
      printf "pipewire failed to find the following path: %s\n" "${pipewire.lib}/${p}"
      error=error
    fi
  '') paths-lib}

  ${lib.concatMapStringsSep "\n" (p: ''
    if [ ! -f "${pipewire}/${p}" ] && [ ! -d "${pipewire}/${p}" ]; then
      printf "pipewire failed to find the following path: %s\n" "${pipewire}/${p}"
      error=error
    fi
  '') paths-out}

  [ -n "$error" ] && exit 1
  touch $out
''
