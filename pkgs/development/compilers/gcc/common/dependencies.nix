{ lib
, stdenv
, version
, buildPackages
, targetPackages
, texinfo
, which
, gettext
, pkg-config
, gnused
, patchelf
, gmp
, mpfr
, libmpc
, cloog ? null
, isl ? null
, zlib ? null
, gnatboot ? null
, flex ? null
, boehmgc
, zip
, unzip
, gtk2
, libart_lgpl
, perl ? null
, xlibs ? null
, langJava ? false
, javaAwtGtk ? false
, langAda ? false
, crossStageStatic ? null
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
  ++ optionals (with stdenv.targetPlatform; isVc4 || isRedox) [ flex ]
  ++ optionals langAda [ gnatboot ]
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
    targetPackages.stdenv.cc.bintools # For linking code at run-time
  ]
  ++ optionals (cloog != null) [ cloog ]
  ++ optionals (isl != null) [ isl ]
  ++ optionals (zlib != null) [ zlib ]
  ++ optionals langJava [ boehmgc zip unzip ]
  ++ optionals javaAwtGtk ([ gtk2 libart_lgpl ] ++ xlibs)
  ;

  # threadsCross.package after gcc6 so i assume its okay for 4.8 and 4.9 too
  depsTargetTarget = optionals (!crossStageStatic && threadsCross != { } && threadsCross.package != null) [ threadsCross.package ];
}
