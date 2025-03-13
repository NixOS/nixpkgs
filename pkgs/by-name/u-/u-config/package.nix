{
  lib,
  stdenv,
  fetchurl,
  noLibc ? stdenv.hostPlatform.isx86 && (stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isMinGW),
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    inherit (lib) optionals escapeShellArgs;
    inherit (stdenv) hostPlatform;

    exe = hostPlatform.extensions.executable;
    binary = finalAttrs.meta.mainProgram + exe;

    platform =
      if noLibc then
        (
          with hostPlatform;
          if isLinux && isx86_32 then
            "linux_i686"
          else if isLinux && isx86_64 then
            "linux_amd64"
          else if isMinGW then
            "win32"
          else
            lib.warn "unsupported system ${system} for libc‐free version, falling back to generic" "generic"
        )
      else
        "generic";

    cppflags = lib.mapAttrsToList (name: value: "-D${name}=\"${value}\"") {
      # set these to empty strings as there are no central directories for
      # pkg-config modules, header files or libraries
      PKG_CONFIG_PREFIX = "";
      PKG_CONFIG_LIBDIR = "";
      PKG_CONFIG_SYSTEM_INCLUDE_PATH = "";
      PKG_CONFIG_SYSTEM_LIBRARY_PATH = "";
    };

    cflags = optionals noLibc (
      [
        # expose memset and memcpy in libmemory.c
        "-DMEMSET"
        "-DMEMCPY"

        "-fno-builtin"
        "-fno-asynchronous-unwind-tables"
        "-Wl,--gc-sections"
      ]
      ++ (
        if hostPlatform.isMinGW then
          [
            "-nostartfiles"
          ]
        else
          [
            "-nostdlib"
            "-static"
          ]
      )
    );

    libs = optionals noLibc (
      [ finalAttrs.libmemory ]
      ++ optionals hostPlatform.isMinGW [
        "-lkernel32"
      ]
    );
  in
  {
    pname = "u-config";
    version = "0.33.3";

    # fetch using fetchurl to permit use during bootstrap
    src = fetchurl {
      url = "https://github.com/skeeto/u-config/releases/download/v${finalAttrs.version}/u-config-${finalAttrs.version}.tar.gz";
      hash = "sha256-wtSGgU99/UJ06Ww5+tmorhBx70It+cvfp2EO8fCH9ew=";
    };

    # provides memset and memcpy for libc‐free versions
    libmemory = fetchurl {
      url = "https://raw.githubusercontent.com/skeeto/w64devkit/cbb4c3f0df7e1412559fde793006b14b5d60b21c/src/libmemory.c";
      hash = "sha256-7hkgWNsFpMk3x+cdOs7UgwOE8NvR8QM/q6izNHNYEjc=";
    };

    nativeBuildInputs = [ installShellFiles ];
    nativeInstallCheckInputs = [ versionCheckHook ];

    hardeningDisable = optionals noLibc [
      "pie"
      "stackprotector"
    ];

    dontConfigure = true;
    doCheck = stdenv.buildPlatform.canExecute hostPlatform;
    doInstallCheck = true;
    versionCheckProgram = "${placeholder "out"}/bin/${binary}";

    # build without using Makefile as recommended by upstream
    buildPhase = ''
      runHook preBuild

      $CC -o ${binary} ${escapeShellArgs cppflags} ${escapeShellArgs cflags} ${platform}_main.c ${escapeShellArgs libs}

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
      maintainers = with lib.maintainers; [
        sigmanificient
        marcin-serwin
        mvs
      ];
      platforms = lib.platforms.all;
      mainProgram = "pkg-config";
    };
  }
)
