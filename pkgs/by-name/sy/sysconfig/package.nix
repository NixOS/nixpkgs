{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  autoPatchelfHook,
  patchelf,
  imagemagick,
  # buildInputs
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libdrm,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  # FHS runtime deps (dlopen'd)
  libGL,
}:

let
  pname = "sysconfig";
  version-short = "1.28.0";
  version-build = "4712";
  version = "${version-short}.${version-build}";

  meta = with lib; {
    description = "TI SysConfig graphical configuration tool for embedded development";
    longDescription = ''
      CCStudio™ SysConfig is part of TI's extensive CCStudio™ development
      ecosystem and is a configuration tool that simplifies hardware and
      software configuration challenges to accelerate software development.

      SysConfig provides an intuitive graphical user interface for
      configuring pins, peripherals, radios, software stacks, RTOS, clock
      trees and other components, and automatically detects, exposes and
      resolves conflicts to speed software development.
    '';
    homepage = "https://www.ti.com/tool/SYSCONFIG";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ bjsowa ];
  };

  unwrapped = stdenvNoCC.mkDerivation {
    pname = "${pname}-unwrapped";

    inherit version meta;

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchurl {
      url = "https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-nsUM6f7Vvb/${version-short}.${version-build}/sysconfig-${version-short}_${version-build}-setup.run";
      sha256 = "1viajqhnwnl6kj30cnyqfpl3i0h5qbwxqf989ygfk5l31igdcb92";
    };

    dontUnpack = true;

    nativeBuildInputs = [
      autoPatchelfHook
      patchelf
      imagemagick
      makeWrapper
      copyDesktopItems
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      expat
      glib
      gtk3
      libdrm
      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxkbcommon
      libxrandr
      mesa # provides libgbm.so.1
      nspr
      nss
      pango
      stdenv.cc.cc.lib # provides libstdc++.so.6, libgomp.so.1 and libatomic.so.1 (for bundled ngspice)
      systemd
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "sysconfig";
        exec = "sysconfig";
        icon = "sysconfig";
        desktopName = "TI SysConfig";
        comment = "TI System Configuration Tool for embedded development";
        categories = [ "Development" ];
        terminal = false;
      })
    ];

    # Run the installer and patch the result.
    # Unlike ccstudio's .zip, this .run is the raw InstallBuilder binary
    # itself. Unlike ccstudio, it doesn't extract/exec any native
    # sub-installers at runtime and its own ELF only needs glibc (libc,
    # libm, libdl, libpthread), so patching its interpreter directly is
    # enough to run it - no FHS/bwrap sandbox needed.
    installPhase = ''
      export TMPDIR=$(mktemp -d)
      install -Dm755 $src $TMPDIR/sysconfig-setup.run
      patchelf --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" \
        $TMPDIR/sysconfig-setup.run

      cd $TMPDIR
      ./sysconfig-setup.run \
        --mode unattended \
        --prefix $out/opt/sysconfig \
        --debuglevel 4 \
        --debugtrace $TMPDIR/sysconfig_install_debug.log

      mkdir -p $out/bin
      makeWrapper "$out/opt/sysconfig/sysconfig_gui.sh" $out/bin/sysconfig
      makeWrapper "$out/opt/sysconfig/sysconfig_cli.sh" $out/bin/sysconfig-cli

      copyDesktopItems

      # Icons
      for size in 16 24 32 48 64 128 256; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick $out/opt/sysconfig/dist/sysconfig.png \
          -resize "$size"x"$size" \
          $out/share/icons/hicolor/"$size"x"$size"/apps/sysconfig.png
      done
    '';
  };

  # Runtime FHS wrapper.
  # autoPatchelfHook resolves most library deps via RPATH, but libGL is
  # dlopen'd at runtime by the nw.js/Chromium GL backend.
in
(buildFHSEnv {
  inherit pname version meta;

  runScript = "${unwrapped}/bin/sysconfig";
  extraInstallCommands = ''
    mkdir -p $out/share
    ln -sf ${unwrapped}/share/applications $out/share/applications
    ln -sf ${unwrapped}/share/icons $out/share/icons

    # The CLI is a plain node process (no GUI/GL deps), so it doesn't need
    # to run inside the FHS sandbox - expose it directly.
    ln -sf ${unwrapped}/bin/sysconfig-cli $out/bin/sysconfig-cli
  '';
  targetPkgs = _: [ libGL ];

  passthru = {
    unwrapped = unwrapped;
  };
}).overrideAttrs
  {
    strictDeps = true;
    __structuredAttrs = true;
  }
