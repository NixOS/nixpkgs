{
  lib,
  stdenv,
  go,
  buildGoModule,
  skopeo,
  testers,
  runCommand,
  bintools,
  clickhouse-backup,
}:
let
  skopeo' = skopeo.override { buildGoModule = buildGoModule; };
  clickhouse-backup' = clickhouse-backup.override { buildGoModule = buildGoModule; };
in
{
  skopeo = testers.testVersion { package = skopeo'; };
  version = testers.testVersion {
    package = go;
    command = "go version";
    version = "go${go.version}";
  };
  # Picked clickhouse-backup as a package that sets CGO_ENABLED=0
  # Running and outputting the right version proves a working ELF interpreter was picked
  clickhouse-backup = testers.testVersion { package = clickhouse-backup'; };
  clickhouse-backup-is-pie = runCommand "has-pie" { meta.broken = stdenv.hostPlatform.isStatic; } ''
    ${lib.optionalString (stdenv.buildPlatform == stdenv.targetPlatform) ''
      if ${lib.getExe' bintools "readelf"} -p .comment ${lib.getExe clickhouse-backup'} | grep -Fq "GCC: (GNU)"; then
        echo "${lib.getExe clickhouse-backup'} has a GCC .comment, but it should have used the internal go linker"
        exit 1
      fi
    ''}
    if ${lib.getExe' bintools "readelf"} -h ${lib.getExe clickhouse-backup'} | grep -q "Type:.*DYN"; then
      touch $out
    else
      echo "ERROR: clickhouse-backup is NOT PIE"
      exit 1
    fi
  '';
}
