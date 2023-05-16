<<<<<<< HEAD
{ lib, stdenv, withoutTargetLibc, langD ? false, libcCross, threadsCross }:
=======
{ lib, stdenv, crossStageStatic, langD ? false, libcCross, threadsCross }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  inherit (stdenv) hostPlatform targetPlatform;
in

{
  # For non-cross builds these flags are currently assigned in builder.sh.
  # It would be good to consolidate the generation of makeFlags
  # ({C,CXX,LD}FLAGS_FOR_{BUILD,TARGET}, etc...) at some point.
  EXTRA_FLAGS_FOR_TARGET = let
      mkFlags = dep: langD: lib.optionals (targetPlatform != hostPlatform && dep != null && !langD) ([
        "-O2 -idirafter ${lib.getDev dep}${dep.incdir or "/include"}"
<<<<<<< HEAD
      ] ++ lib.optionals (! withoutTargetLibc) [
        "-B${lib.getLib dep}${dep.libdir or "/lib"}"
      ]);
    in mkFlags libcCross langD
       ++ lib.optionals (!withoutTargetLibc) (mkFlags (threadsCross.package or null) langD)
=======
      ] ++ lib.optionals (! crossStageStatic) [
        "-B${lib.getLib dep}${dep.libdir or "/lib"}"
      ]);
    in mkFlags libcCross langD
       ++ lib.optionals (!crossStageStatic) (mkFlags (threadsCross.package or null) langD)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ;

  EXTRA_LDFLAGS_FOR_TARGET = let
      mkFlags = dep: lib.optionals (targetPlatform != hostPlatform && dep != null) ([
        "-Wl,-L${lib.getLib dep}${dep.libdir or "/lib"}"
<<<<<<< HEAD
      ] ++ (if withoutTargetLibc then [
=======
      ] ++ (if crossStageStatic then [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          "-B${lib.getLib dep}${dep.libdir or "/lib"}"
        ] else [
          "-Wl,-rpath,${lib.getLib dep}${dep.libdir or "/lib"}"
          "-Wl,-rpath-link,${lib.getLib dep}${dep.libdir or "/lib"}"
      ]));
    in mkFlags libcCross
<<<<<<< HEAD
       ++ lib.optionals (!withoutTargetLibc) (mkFlags (threadsCross.package or null))
=======
       ++ lib.optionals (!crossStageStatic) (mkFlags (threadsCross.package or null))
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ;
}
