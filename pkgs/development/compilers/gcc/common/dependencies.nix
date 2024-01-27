{ lib
, stdenv
, version
, buildPackages
, targetPackages
, texinfo
, which
, gettext
, pkg-config ? null
, gnused
, patchelf
, gmp
, mpfr
, libmpc
, libucontext ? null
, libxcrypt ? null
, cloog ? null
, isl ? null
, zlib ? null
, gnat-bootstrap ? null
, flex ? null
, boehmgc ? null
, zip ? null
, unzip ? null
, gtk2 ? null
, libart_lgpl ? null
, perl ? null
, xlibs ? null
, langJava ? false
, javaAwtGtk ? false
, langAda ? false
, langGo ? false
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
  ++ optionals javaAwtGtk [ pkg-config ]
  ++ optionals (with stdenv.targetPlatform; isVc4 || isRedox && flex != null) [ flex ]
  ++ optionals langAda [ gnat-bootstrap ]
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
  ++ optionals (lib.versionOlder version "5" && cloog != null) [ cloog ]
  ++ optionals (isl != null) [ isl ]
  ++ optionals (zlib != null) [ zlib ]
  ++ optionals langJava [ boehmgc zip unzip ]
  ++ optionals javaAwtGtk ([ gtk2 libart_lgpl ] ++ xlibs)
  ++ optionals (langGo && stdenv.hostPlatform.isMusl) [ libucontext ]
  ;

  # threadsCross.package after gcc6 so i assume its okay for 4.8 and 4.9 too
  depsTargetTarget = optionals (!withoutTargetLibc && threadsCross != { } && threadsCross.package != null) [ threadsCross.package ];
}
