{ lib
, stdenv
, callPackage
, flutter
, buildFHSUserEnv
, runCommandLocal
, supportsAndroidEmulator ? stdenv.isLinux
}:


# Wrap flutter inside an fhs user env to allow execution of binary,
# like adb from $ANDROID_HOME or java from android-studio.
(callPackage ./sdk-symlink.nix { }) (buildFHSUserEnv rec {
  name = "${flutter.name}-fhs";

  multiPkgs = pkgs: with pkgs; ([
    # Flutter only use these certificates
    (runCommandLocal "fedoracert" { } ''
      mkdir -p $out/etc/pki/tls/
      ln -s ${cacert}/etc/ssl/certs $out/etc/pki/tls/certs
    '')
    zlib
  ]);

  targetPkgs = pkgs: with pkgs; ([
    flutter

    # General ecosystem dependencies
    bash
    curl
    git
    unzip
    which
    xz

    # flutter test requires this lib
    libGLU
  ] ++ lib.optional supportsAndroidEmulator [
    # for android emulator
    alsa-lib
    dbus
    expat
    libpulseaudio
    libuuid
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    libGL
    nspr
    nss
    systemd
  ]);

  runScript = "flutter";

  extraInstallCommands = ''
    # By default, the derivation name is used as the binary name.
    # This is not the desired behaviour in this case.
    # https://github.com/NixOS/nixpkgs/blob/cb4536bf3606a7b6b54b69afe22ccd82e2906d92/pkgs/build-support/build-fhs-userenv/default.nix#L43
    mv $out/bin/${name} $out/bin/flutter
  '';

  passthru = flutter.passthru // {
    nonFHS = flutter;
    mkFlutterApp = callPackage ../../../build-support/flutter {
      flutter = callPackage ./fhs.nix { supportsAndroidEmulator = false; };
    };
  };

  meta = flutter.meta // {
    longDescription = ''
      ${flutter.meta.longDescription}
      Wrapped in a FHS environment to improve compatibility with internal tools and tools in the ecosystem.
    '';
  };
})
