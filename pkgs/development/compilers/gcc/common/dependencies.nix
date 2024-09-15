{ lib
, stdenv
, version
, buildPackages
, targetPackages
, texinfo
, which
, gettext
, gnused
, patchelf
, gmp
, mpfr
, libmpc
, libucontext ? null
, libxcrypt ? null
, darwin ? null
, isl ? null
, zlib ? null
, gnat-bootstrap ? null
, flex ? null
, perl ? null
, langAda ? false
, langGo ? false
, langRust ? false
, cargo
, withoutTargetLibc ? null
, threadsCross ? null
}:

let
  inherit (lib) optionals;
  inherit (stdenv) buildPlatform hostPlatform targetPlatform;
in

{
  # same for all gcc's
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    texinfo
    which
    gettext
  ]
  ++ optionals (perl != null) [ perl ]
  ++ optionals (with stdenv.targetPlatform; isVc4 || isRedox && flex != null) [ flex ]
  ++ optionals langAda [ gnat-bootstrap ]
  ++ optionals langRust [ cargo ]
  # The builder relies on GNU sed (for instance, Darwin's `sed' fails with
  # "-i may not be used with stdin"), and `stdenvNative' doesn't provide it.
  ++ optionals buildPlatform.isDarwin [ gnused ]
  ;

  # For building runtime libs
  # same for all gcc's
  depsBuildTarget =
    (
      if hostPlatform == buildPlatform then [
        targetPackages.stdenv.cc.bintools # newly-built gcc will be used
      ] else assert targetPlatform == hostPlatform; [
        # build != host == target
        stdenv.cc
      ]
    )
    ++ optionals targetPlatform.isLinux [ patchelf ];

  buildInputs = [
    gmp
    mpfr
    libmpc
  ]
  ++ optionals (lib.versionAtLeast version "10") [ libxcrypt ]
  ++ [
    targetPackages.stdenv.cc.bintools # For linking code at run-time
  ]
  ++ optionals (isl != null) [ isl ]
  ++ optionals (zlib != null) [ zlib ]
  ++ optionals (langGo && stdenv.hostPlatform.isMusl) [ libucontext ]
  ++ optionals (lib.versionAtLeast version "14" && stdenv.hostPlatform.isDarwin) [ darwin.apple_sdk.frameworks.CoreServices ]
  ;

  depsTargetTarget = optionals (!withoutTargetLibc && threadsCross != { } && threadsCross.package != null) [ threadsCross.package ];
}
