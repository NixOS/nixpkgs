{ stdenv, crossStageStatic, langD ? false, libcCross, threadsCross }:

let
  inherit (stdenv) lib hostPlatform targetPlatform;
in

{
  EXTRA_TARGET_FLAGS = let
      mkFlags = dep: langD: lib.optionals (targetPlatform != hostPlatform && dep != null && !langD) ([
        "-idirafter ${lib.getDev dep}${dep.incdir or "/include"}"
      ] ++ stdenv.lib.optionals (! crossStageStatic) [
        "-B${lib.getLib dep}${dep.libdir or "/lib"}"
      ]);
    in mkFlags libcCross langD
    ++ lib.optionals (!crossStageStatic) (mkFlags threadsCross langD)
    ;

  EXTRA_TARGET_LDFLAGS = let
      mkFlags = dep: lib.optionals (targetPlatform != hostPlatform && dep != null) ([
        "-Wl,-L${lib.getLib dep}${dep.libdir or "/lib"}"
      ] ++ (if crossStageStatic then [
          "-B${lib.getLib dep}${dep.libdir or "/lib"}"
        ] else [
          "-Wl,-rpath,${lib.getLib dep}${dep.libdir or "/lib"}"
          "-Wl,-rpath-link,${lib.getLib dep}${dep.libdir or "/lib"}"
      ]));
    in mkFlags libcCross
    ++ lib.optionals (!crossStageStatic) (mkFlags threadsCross)
    ;
}
