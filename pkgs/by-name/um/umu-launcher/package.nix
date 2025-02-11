{
  buildFHSEnv,
  lib,
  umu-launcher-unwrapped,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  extraProfile ? "", # string to append to profile
  extraEnv ? { }, # Environment variables to pass to Steam
  withMultiArch ? true, # Many Wine games need 32-bit libraries.
}:
buildFHSEnv {
  pname = "umu-launcher";
  inherit (umu-launcher-unwrapped) version meta;

  targetPkgs =
    pkgs:
    [
      # Use umu-launcher-unwrapped from the package args, to support overriding
      umu-launcher-unwrapped
    ]
    ++ extraPkgs pkgs;
  multiPkgs = extraLibraries;
  multiArch = withMultiArch;

  executableName = umu-launcher-unwrapped.meta.mainProgram;
  runScript = lib.getExe umu-launcher-unwrapped;

  extraInstallCommands = ''
    ln -s ${umu-launcher-unwrapped}/lib $out/lib
    ln -s ${umu-launcher-unwrapped}/share $out/share
  '';

  # For umu & proton, we need roughly the same environment as steam.
  # See https://github.com/NixOS/nixpkgs/issues/297662#issuecomment-2647656699
  #
  # TODO: if it was exposed as a drv attr, it might be nice to re-use steam's implementation.
  profile = ''
    # prevents log spam from SteamRT GTK trying to load host GIO modules
    unset GIO_EXTRA_MODULES

    # udev event notifications don't work reliably inside containers.
    # SDL2 already tries to automatically detect flatpak and pressure-vessel
    # and falls back to inotify-based discovery [1]. We make SDL2 do the
    # same by telling it explicitly.
    #
    # [1] <https://github.com/libsdl-org/SDL/commit/8e2746cfb6e1f1a1da5088241a1440fd2535e321>
    export SDL_JOYSTICK_DISABLE_UDEV=1

    # This is needed for IME (e.g. iBus, fcitx5) to function correctly on non-CJK locales
    # https://github.com/ValveSoftware/steam-for-linux/issues/781#issuecomment-2004757379
    export GTK_IM_MODULE='xim'

    # See https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md#graphics-driver
    export LIBGL_DRIVERS_PATH=/run/opengl-driver/lib/dri:/run/opengl-driver-32/lib/dri
    export __EGL_VENDOR_LIBRARY_DIRS=/run/opengl-driver/share/glvnd/egl_vendor.d:/run/opengl-driver-32/share/glvnd/egl_vendor.d
    export LIBVA_DRIVERS_PATH=/run/opengl-driver/lib/dri:/run/opengl-driver-32/lib/dri
    export VDPAU_DRIVER_PATH=/run/opengl-driver/lib/vdpau:/run/opengl-driver-32/lib/vdpau

    set -a
    ${lib.toShellVars extraEnv}
    set +a

    ${extraProfile}
  '';
}
