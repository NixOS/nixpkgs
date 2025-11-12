{
  lib,
  runCommand,
  runtimeShell,
  writeShellScript,
}:

{
  microhs,
  packages,
}:

let
  packages' = [ microhs ] ++ lib.filter (p: p != null) packages;
  extraFlags = lib.concatMapStringsSep " " (
    p: "-a${p}/lib/mcabal/${microhs.haskellCompilerName}"
  ) packages';

  wrapper = writeShellScript "mhs-wrapper" ''
    #!${runtimeShell}
    args=("$@")
    noExtra=0
    for ((i=0; i<"''${#args[@]}"; ++i)); do
      case "''${args[i]}" in
        --version | --numeric-version)
          noExtra=1
          ;;
        *)
          ;;
      esac
    done
    if test "$noExtra" -eq 0; then
      for arg in ${extraFlags}; do
        args[i++]="$arg"
      done
    fi
    printf 'mhs-wrapper: mhs %s\n' "''${args[*]}" >&2
    exec ${microhs}/bin/mhs "''${args[@]}"
  '';

in
runCommand "${microhs.name}-wrapped"
  {
    inherit (microhs) passthru;
  }
  ''
    mkdir -p $out/bin
    cp -rs ${microhs}/bin/* $out/bin/
    rm $out/bin/mhs 2>/dev/null || true
    cp ${wrapper} $out/bin/mhs
  ''
