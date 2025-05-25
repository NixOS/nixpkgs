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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uutils-coreutils";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    tag = finalAttrs.version;
    hash = "sha256-nKKjc6Bui7k50SR7BY09dRGt3Za1Ch/E+3KiCO5KtOg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "uutils-coreutils-${finalAttrs.version}";
    hash = "sha256-PTIypl9uqFkp6GrF7Pp40AItbWFlXT2V2x/C8L2J8S0=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    python3Packages.sphinx
  ];

  makeFlags =
    [
      "CARGO=${lib.getExe cargo}"
      "PREFIX=${placeholder "out"}"
      "PROFILE=release"
      "INSTALLDIR_MAN=${placeholder "out"}/share/man/man1"
    ]
    ++ lib.optionals (prefix != null) [ "PROG_PREFIX=${prefix}" ]
    ++ lib.optionals buildMulticallBinary [ "MULTICALL=y" ];

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
    maintainers = with lib.maintainers; [ siraben ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
