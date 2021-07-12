{ lib, runCommand, pipewire, paths-out, paths-lib, paths-out-media-session }:

let
  check-path = output: path: ''
    if [[ ! -f "${output}/${path}" && ! -d "${output}/${path}" ]]; then
      printf "Missing: %s\n" "${output}/${path}" | tee -a $out
      error=error
    else
      printf "Found: %s\n" "${output}/${path}" | tee -a $out
    fi
  '';

  check-output = output: lib.concatMapStringsSep "\n" (check-path output);
in runCommand "pipewire-test-paths" { } ''
  touch $out

  ${check-output pipewire.mediaSession paths-out-media-session}
  ${check-output pipewire.lib paths-lib}
  ${check-output pipewire paths-out}

  if [[ -n "$error" ]]; then
    exit 1
  fi
''
