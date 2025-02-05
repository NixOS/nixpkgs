{
  lib,
  stdenv,
  withoutTargetLibc,
  langD ? false,
  libcCross,
  threadsCross,
}:

let
  inherit (stdenv) hostPlatform targetPlatform;
in

{
  # For non-cross builds these flags are currently assigned in builder.sh.
  # It would be good to consolidate the generation of makeFlags
  # ({C,CXX,LD}FLAGS_FOR_{BUILD,TARGET}, etc...) at some point.
  EXTRA_FLAGS_FOR_TARGET =
    let
      mkFlags =
        dep: langD:
        lib.optionals (targetPlatform != hostPlatform && dep != null && !langD) (
          [
            "-O2 -idirafter ${lib.getDev dep}${dep.incdir or "/include"}"
          ]
          ++ lib.optionals (!withoutTargetLibc) [
            "-B${lib.getLib dep}${dep.libdir or "/lib"}"
          ]
        );
    in
    mkFlags libcCross langD
    ++ lib.optionals (!withoutTargetLibc) (mkFlags (threadsCross.package or null) langD);

  EXTRA_LDFLAGS_FOR_TARGET =
    let
      mkFlags =
        dep:
        lib.optionals (targetPlatform != hostPlatform && dep != null) (
          [
            "-Wl,-L${lib.getLib dep}${dep.libdir or "/lib"}"
          ]
          ++ (
            if withoutTargetLibc then
              [
                "-B${lib.getLib dep}${dep.libdir or "/lib"}"
              ]
            else
              [
                "-Wl,-rpath,${lib.getLib dep}${dep.libdir or "/lib"}"
                "-Wl,-rpath-link,${lib.getLib dep}${dep.libdir or "/lib"}"
              ]
          )
        );
    in
    mkFlags libcCross ++ lib.optionals (!withoutTargetLibc) (mkFlags (threadsCross.package or null));
}
