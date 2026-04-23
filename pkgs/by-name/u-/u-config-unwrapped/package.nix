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
            "windows"
          else
            lib.warn "unsupported system ${system} for libc‐free version, falling back to posix" "posix"
        )
      else
        "posix";

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
    version = "0.34.0";

    outputs = [
      "out"
      "man"
    ];

    # fetch using fetchurl to permit use during bootstrap
    src = fetchurl {
      url = "https://github.com/skeeto/u-config/releases/download/v${finalAttrs.version}/u-config-${finalAttrs.version}.tar.gz";
      hash = "sha256-xt+8G5SI5f3UpJmjxfe5aMfYkTUvm+dUyQq56qgFrj4=";
    };

    # provides memset and memcpy for libc‐free versions
    libmemory = fetchurl {
      url = "https://raw.githubusercontent.com/skeeto/w64devkit/cbb4c3f0df7e1412559fde793006b14b5d60b21c/src/libmemory.c";
      hash = "sha256-7hkgWNsFpMk3x+cdOs7UgwOE8NvR8QM/q6izNHNYEjc=";
    };

    # u-config does not provide its own pkg.m4
    pkgM4 = fetchurl {
      url = "https://raw.githubusercontent.com/pkgconf/pkgconf/1d37e711cefe83e6b5393b424af4c94da4e7e9d3/pkg.m4";
      hash = "sha256-B/kN59rXR4I0wXDdjIW9urklLk2eP8TSxU7ydP83AUE=";
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

      $CC -o ${binary} ${escapeShellArgs cppflags} ${escapeShellArgs cflags} main_${platform}.c ${escapeShellArgs libs}

      runHook postBuild
    '';

    checkPhase = ''
      runHook preCheck

      $CC -o tests${exe} ${escapeShellArgs cppflags} main_test.c
      ./tests${exe}

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      installBin ${binary}
      installManPage u-config.1

      # pkg-config-wrapper requires this to be provided by unwrapped package
      mkdir -p "$out/share/aclocal"
      ln -s ${finalAttrs.pkgM4} "$out/share/aclocal/pkg.m4"

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Smaller, simpler, portable pkg-config clone";
      homepage = "https://github.com/skeeto/u-config";
      license = with lib.licenses; [
        unlicense # u-config
        gpl2Plus # pkg.m4
      ];

      maintainers = with lib.maintainers; [
        sigmanificient
        marcin-serwin
        mvs
      ];

      platforms = with lib.platforms; unix ++ windows;
      mainProgram = "pkg-config";
    };
  }
)
