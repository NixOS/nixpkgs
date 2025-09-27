{
  lib,
  stdenv,
  version,
  buildPackages,
  targetPackages,
  texinfo,
  which,
  gettext,
  gnused,
  patchelf,
  gmp,
  mpfr,
  libmpc,
  libucontext ? null,
  libxcrypt ? null,
  isSnapshot ? false,
  isl ? null,
  zlib ? null,
  gnat-bootstrap ? null,
  flex ? null,
  perl ? null,
  langAda ? false,
  langGo ? false,
  langRust ? false,
  cargo,
  withoutTargetLibc ? null,
  threadsCross ? null,
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
  ++ optionals (with stdenv.targetPlatform; isVc4 || isRedox || isSnapshot && flex != null) [ flex ]
  ++ optionals langAda [ gnat-bootstrap ]
  ++ optionals langRust [ cargo ]
  # The builder relies on GNU sed (for instance, Darwin's `sed' fails with
  # "-i may not be used with stdin"), and `stdenvNative' doesn't provide it.
  ++ optionals buildPlatform.isDarwin [ gnused ];

  # For building runtime libs
  # same for all gcc's
  depsBuildTarget =
    (
      if lib.systems.equals hostPlatform buildPlatform then
        [
          targetPackages.stdenv.cc.bintools # newly-built gcc will be used
        ]
      else
        assert lib.systems.equals targetPlatform hostPlatform;
        [
          # build != host == target
          stdenv.cc
        ]
    )
    ++ optionals targetPlatform.isLinux [ patchelf ];

  buildInputs = [
    gmp
    mpfr
    libmpc
    libxcrypt
  ]
  ++ [
    targetPackages.stdenv.cc.bintools # For linking code at run-time
  ]
  ++ optionals (isl != null) [ isl ]
  ++ optionals (zlib != null) [ zlib ]
  ++ optionals (langGo && stdenv.hostPlatform.isMusl) [ libucontext ];

  depsTargetTarget = optionals (
    !withoutTargetLibc && threadsCross != { } && threadsCross.package != null
  ) [ threadsCross.package ];
}
