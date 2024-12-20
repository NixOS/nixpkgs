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
  darwin ? null,
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

  ## llvm18 fails with gcc <14
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=114419
  llvmAmd = buildPackages.runCommand "${buildPackages.llvm.name}-wrapper" {} ''
    mkdir -p $out/bin
    for a in ar nm ranlib; do
      ln -s ${buildPackages.llvmPackages.llvm}/bin/llvm-$a $out/bin/amdgcn-amdhsa-$a
    done
    ln -s ${buildPackages.llvmPackages.llvm}/bin/llvm-mc $out/bin/amdgcn-amdhsa-as
    ln -s ${buildPackages.llvmPackages.lld}/bin/lld $out/bin/amdgcn-amdhsa-ld
  '';
in

{
  # same for all gcc's
  depsBuildBuild = [ buildPackages.stdenv.cc ] ++
      lib.optional (targetPlatform.config == "amdgcn-amdhsa") llvmAmd;

  nativeBuildInputs =
    [
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
    ++ optionals buildPlatform.isDarwin [ gnused ];

  # For building runtime libs
  # same for all gcc's
  depsBuildTarget =
    (
      if (targetPlatform.config == "amdgcn-amdhsa") then
        [ ]
      else if hostPlatform == buildPlatform then
        [
          targetPackages.stdenv.cc.bintools # newly-built gcc will be used
        ]
      else
        assert targetPlatform == hostPlatform;
        [
          # build != host == target
          stdenv.cc
        ]
    )
    ++ optionals targetPlatform.isLinux [ patchelf ];

  buildInputs =
    [
      gmp
      mpfr
      libmpc
    ]
    ++ optionals (lib.versionAtLeast version "10") [ libxcrypt ]
    ++ optionals (targetPlatform.config != "amdgcn-amdhsa") [
      targetPackages.stdenv.cc.bintools # For linking code at run-time
    ]
    ++ optionals (isl != null) [ isl ]
    ++ optionals (zlib != null) [ zlib ]
    ++ optionals (langGo && stdenv.hostPlatform.isMusl) [ libucontext ]
    ++ optionals (lib.versionAtLeast version "14" && stdenv.hostPlatform.isDarwin) [
      darwin.apple_sdk.frameworks.CoreServices
    ];

  depsTargetTarget = optionals (
    !withoutTargetLibc && threadsCross != { } && threadsCross.package != null
  ) [ threadsCross.package ];
}
