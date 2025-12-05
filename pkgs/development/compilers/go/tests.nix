{
  lib,
  stdenv,
  go,
  buildGoModule,
  # A package that relies on CGO
  skopeo,
  testers,
  runCommand,
  bintools,
  # A package with CGO_ENABLED=0
  athens,
}:
let
  skopeo' = skopeo.override { buildGoModule = buildGoModule; };
  athens' = athens.override { buildGoModule = buildGoModule; };
  expectedCgoEnabledType = "DYN";
  expectedCgoDisabledType = "EXE";
in
{
  skopeo = testers.testVersion { package = skopeo'; };
  version = testers.testVersion {
    package = go;
    command = "go version";
    version = "go${go.version}";
  };
  athens = testers.testVersion { package = athens'; };
}
# bin type tests assume ELF file + linux-specific exe types
// lib.optionalAttrs stdenv.hostPlatform.isLinux {
  skopeo-bin-type = runCommand "skopeo-bin-type" { meta.broken = stdenv.hostPlatform.isStatic; } ''
    bin="${lib.getExe' skopeo' ".skopeo-wrapped"}"
    if ! ${lib.getExe' bintools "readelf"} -p .comment $bin | grep -Fq "GCC: (GNU)"; then
      echo "${lib.getExe skopeo} should have been externally linked, but no GNU .comment section found"
      exit 1
    fi
    if ${lib.getExe' bintools "readelf"} -h $bin | grep -q "Type:.*${expectedCgoEnabledType}"; then
      touch $out
    else
      echo "ERROR: $bin is NOT ${expectedCgoEnabledType}"
      exit 1
    fi
  '';
  athens-bin-type = runCommand "athens-bin-type" { meta.broken = stdenv.hostPlatform.isStatic; } ''
    bin="${lib.getExe athens'}"
    ${lib.optionalString (stdenv.buildPlatform == stdenv.targetPlatform) ''
      # For CGO_ENABLED=0 the internal linker should be used, except
      # for cross where we rely on external linking by default
      if ${lib.getExe' bintools "readelf"} -p .comment ${lib.getExe athens'} | grep -Fq "GCC: (GNU)"; then
        echo "${lib.getExe athens'} has a GCC .comment, but it should have used the internal go linker"
        exit 1
      fi
    ''}
    if ${lib.getExe' bintools "readelf"} -h "$bin" | grep -q "Type:.*${expectedCgoDisabledType}"; then
      touch $out
    else
      echo "ERROR: $bin is NOT ${expectedCgoDisabledType}"
      exit 1
    fi
  '';
}
