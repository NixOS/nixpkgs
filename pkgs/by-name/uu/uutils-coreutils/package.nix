{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  python3Packages,
  versionCheckHook,
  nix-update-script,

  prefix ? "uutils-",
  buildMulticallBinary ? true,

  selinuxSupport ? false,
  libselinux,

  acl,
}:

assert selinuxSupport -> lib.meta.availableOn stdenv.hostPlatform libselinux;

stdenv.mkDerivation (finalAttrs: {
  pname = "uutils-coreutils";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    tag = finalAttrs.version;
    hash = "sha256-jxjg2RIZaemA6jgfdE1KX8G6c/NWumecoJMFx7dspz8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "uutils-coreutils-${finalAttrs.version}";
    hash = "sha256-SFuAWzmYd1N7czUyC/7CYrCObYfoKrC5oORFxXtbwhE=";
  };

  patches = [
    ./selinux_no_auto_detect.diff
  ];

  buildInputs =
    lib.optionals (lib.meta.availableOn stdenv.hostPlatform acl) [
      acl
    ]
    ++ lib.optionals selinuxSupport [
      libselinux
    ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    python3Packages.sphinx
  ];

  makeFlags = [
    "CARGO=${lib.getExe cargo}"
    "PREFIX=${placeholder "out"}"
    "PROFILE=release"
    "SELINUX_ENABLED=${if selinuxSupport then "1" else "0"}"
    "INSTALLDIR_MAN=${placeholder "out"}/share/man/man1"
    # Explicitly enable acl, and if requested selinux.
    # We cannot rely on SELINUX_ENABLED here since our explicit assignment
    # overrides its effect in the makefile.
    "BUILD_SPEC_FEATURE=${
      lib.concatStringsSep "," (
        # We can always enable acl, on non-Linux, libc provides the headers,
        # only in Linux we need to add the acl lib to buildInputs.
        [
          "feat_acl"
        ]
        ++ (lib.optionals selinuxSupport [
          "feat_selinux"
        ])
      )
    }"
  ]
  ++ lib.optionals (prefix != null) [ "PROG_PREFIX=${prefix}" ]
  ++ lib.optionals buildMulticallBinary [ "MULTICALL=y" ];

  env = lib.optionalAttrs selinuxSupport {
    SELINUX_INCLUDE_DIR = ''${libselinux.dev}/include'';
    SELINUX_LIB_DIR = lib.makeLibraryPath [
      libselinux
    ];
    SELINUX_STATIC = "0";
  };

  # too many impure/platform-dependent tests
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram =
    let
      prefix' = lib.optionalString (prefix != null) prefix;
    in
    "${placeholder "out"}/bin/${prefix'}ls";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cross-platform Rust rewrite of the GNU coreutils";
    longDescription = ''
      uutils is an attempt at writing universal (as in cross-platform)
      CLI utils in Rust. This repo is to aggregate the GNU coreutils rewrites.
    '';
    homepage = "https://github.com/uutils/coreutils";
    changelog = "https://github.com/uutils/coreutils/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      siraben
      matthiasbeyer
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
