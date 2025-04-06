{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    inherit (lib) escapeShellArgs;

    exe = stdenv.hostPlatform.extensions.executable;
    binary = finalAttrs.meta.mainProgram + exe;
    cppflags = lib.mapAttrsToList (name: value: "-D${name}=\"${value}\"") {
      # set these to empty strings as there are no central directories for
      # pkg-config modules, header files or libraries
      PKG_CONFIG_PREFIX = "";
      PKG_CONFIG_LIBDIR = "";
      PKG_CONFIG_SYSTEM_INCLUDE_PATH = "";
      PKG_CONFIG_SYSTEM_LIBRARY_PATH = "";
    };
  in
  {
    pname = "u-config";
    version = "0.33.3";

    # fetch using fetchurl to permit use during bootstrap
    src = fetchurl {
      url = "https://github.com/skeeto/u-config/releases/download/v${finalAttrs.version}/u-config-${finalAttrs.version}.tar.gz";
      hash = "sha256-wtSGgU99/UJ06Ww5+tmorhBx70It+cvfp2EO8fCH9ew=";
    };

    nativeBuildInputs = [ installShellFiles ];
    nativeInstallCheckInputs = [ versionCheckHook ];

    dontConfigure = true;
    doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
    doInstallCheck = true;
    versionCheckProgram = "${placeholder "out"}/bin/${binary}";

    # build without using Makefile as recommended by upstream
    buildPhase = ''
      runHook preBuild

      $CC -o ${binary} ${escapeShellArgs cppflags} generic_main.c

      runHook postBuild
    '';

    checkPhase = ''
      runHook preCheck

      $CC -o tests${exe} ${escapeShellArgs cppflags} test_main.c
      ./tests${exe}

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      installBin ${binary}

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Smaller, simpler, portable pkg-config clone";
      homepage = "https://github.com/skeeto/u-config";
      license = lib.licenses.unlicense;
      maintainers = with lib.maintainers; [ sigmanificient ];
      platforms = lib.platforms.all;
      mainProgram = "pkg-config";
    };
  }
)
