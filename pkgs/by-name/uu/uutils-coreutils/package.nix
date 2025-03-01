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

stdenv.mkDerivation rec {
  pname = "uutils-coreutils";
  version = "0.0.29";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    tag = version;
    hash = "sha256-B6lz75uxROo7npiZNCdTt0NCxVvsaIgtWnuGOKevDQQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "uutils-coreutils-${version}";
    hash = "sha256-Z5A1Tyf7SbvIBVGG3YPxh4q/SLU+yNlVv2jBRNumNwM=";
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
  versionCheckProgramArg = [ "--version" ];
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
    changelog = "https://github.com/uutils/coreutils/releases/tag/${version}";
    maintainers = with lib.maintainers; [ siraben ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
