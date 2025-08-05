{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  buildFHSEnv,
  extraPkgs ? pkgs: [ ],
  extraLibs ? pkgs: [ ],
}:

stdenv.mkDerivation rec {
  pname = "unityhub";
  version = "3.13.1";

  src = fetchurl {
    url = "https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${version}.deb";
    hash = "sha256-gBQrz6CNlUyhxeLmY6tNtxpaQJSEW00r7MGyIDtYdiY=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  fhsEnv = buildFHSEnv {
    pname = "${pname}-fhs-env";
    inherit version;
    runScript = "";

    targetPkgs =
      pkgs:
      with pkgs;
      [
        # Unity Hub binary dependencies
        xorg.libXrandr
        xdg-utils

        # GTK filepicker
        gsettings-desktop-schemas
        hicolor-icon-theme

        # Bug Reporter dependencies
        fontconfig
        freetype
        lsb-release
      ]
      ++ extraPkgs pkgs;

    multiPkgs =
      pkgs:
      with pkgs;
      [
        # Unity Hub ldd dependencies
        cups
        gtk3
        expat
        libxkbcommon
        lttng-ust_2_12
        krb5
        alsa-lib
        nss
        libdrm
        libgbm
        nspr
        atk
        dbus
        at-spi2-core
        pango
        xorg.libXcomposite
        xorg.libXext
        xorg.libXdamage
        xorg.libXfixes
        xorg.libxcb
        xorg.libxshmfence
        xorg.libXScrnSaver
        xorg.libXtst

        # Unity Hub additional dependencies
        libva
        openssl
        cairo
        libnotify
        libuuid
        libsecret
        udev
        libappindicator
        wayland
        cpio
        icu
        libpulseaudio

        # Unity Editor dependencies
        libglvnd # provides ligbl
        xorg.libX11
        xorg.libXcursor
        glib
        gdk-pixbuf
        (libxml2.overrideAttrs (oldAttrs: rec {
          version = "2.13.8";
          src = fetchurl {
            url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
            hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
          };
          meta = oldAttrs.meta // {
            knownVulnerabilities = oldAttrs.meta.knownVulnerabilities or [ ] ++ [
              "CVE-2025-6021"
            ];
          };
        }))
        zlib
        clang
        git # for git-based packages in unity package manager

        # Unity Editor 6000 specific dependencies
        harfbuzz
        vulkan-loader

        # Unity Bug Reporter specific dependencies
        xorg.libICE
        xorg.libSM

        # Fonts used by built-in and third party editor tools
        corefonts
        dejavu_fonts
        liberation_ttf
      ]
      ++ extraLibs pkgs;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv opt/ usr/share/ $out

    # `/opt/unityhub/unityhub` is a shell wrapper that runs `/opt/unityhub/unityhub-bin`
    # which we don't need and overwrite with our own wrapper that uses the fhs env.
    makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/opt/unityhub/unityhub \
      --add-flags $out/opt/unityhub/unityhub-bin \
      --argv0 unityhub

    mkdir -p $out/bin
    ln -s $out/opt/unityhub/unityhub $out/bin/unityhub

    # Replace absolute path in desktop file to correctly point to nix store
    substituteInPlace $out/share/applications/unityhub.desktop \
      --replace-fail /opt/unityhub/unityhub $out/opt/unityhub/unityhub

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Official Unity3D app to download and manage Unity Projects and installations";
    homepage = "https://unity.com/";
    downloadPage = "https://unity.com/unity-hub";
    changelog = "https://unity.com/unity-hub/release-notes#${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ huantian ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
