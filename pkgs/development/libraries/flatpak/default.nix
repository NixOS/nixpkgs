{ lib, stdenv
, fetchurl
, autoreconfHook
, docbook_xml_dtd_45
, docbook-xsl-nons
, which
, libxml2
, gobject-introspection
, gtk-doc
, intltool
, libxslt
, pkg-config
, xmlto
, substituteAll
, runCommand
, bison
, xdg-dbus-proxy
, p11-kit
, appstream
, bubblewrap
, bzip2
, curl
, dbus
, glib
, gpgme
, json-glib
, libarchive
, libcap
, libseccomp
, coreutils
, socat
, gettext
, hicolor-icon-theme
, shared-mime-info
, desktop-file-utils
, gtk3
, fuse3
, nixosTests
, xz
, zstd
, ostree
, polkit
, python3
, systemd
, xorg
, valgrind
, glib-networking
, wrapGAppsNoGuiHook
, dconf
, gsettings-desktop-schemas
, librsvg
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flatpak";
  version = "1.14.5";

  # TODO: split out lib once we figure out what to do with triggerdir
  outputs = [ "out" "dev" "man" "doc" "devdoc" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${finalAttrs.version}/flatpak-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-W3DGTOesE04eoIARJW5COuXFTydyl0QVg/d9AT8n/6w="; # Taken from https://github.com/flatpak/flatpak/releases/
  };

  patches = [
    # Hardcode paths used by tests and change test runtime generation to use files from Nix store.
    # https://github.com/flatpak/flatpak/issues/1460
    (substituteAll {
      src = ./fix-test-paths.patch;
      inherit coreutils gettext socat gtk3;
      smi = shared-mime-info;
      dfu = desktop-file-utils;
      hicolorIconTheme = hicolor-icon-theme;
    })

    # Hardcode paths used by Flatpak itself.
    (substituteAll {
      src = ./fix-paths.patch;
      p11kit = "${p11-kit.bin}/bin/p11-kit";
    })

    # Allow gtk-doc to find schemas using XML_CATALOG_FILES environment variable.
    # Patch taken from gtk-doc expression.
    ./respect-xml-catalog-files-var.patch

    # Nix environment hacks should not leak into the apps.
    # https://github.com/NixOS/nixpkgs/issues/53441
    ./unset-env-vars.patch

    # Use flatpak from PATH to avoid references to `/nix/store` in `/desktop` files.
    # Applications containing `DBusActivatable` entries should be able to find the flatpak binary.
    # https://github.com/NixOS/nixpkgs/issues/138956
    ./binary-path.patch

    # The icon validator needs to access the gdk-pixbuf loaders in the Nix store
    # and cannot bind FHS paths since those are not available on NixOS.
    finalAttrs.passthru.icon-validator-patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    libxml2
    docbook_xml_dtd_45
    docbook-xsl-nons
    which
    gobject-introspection
    gtk-doc
    intltool
    libxslt
    pkg-config
    xmlto
    bison
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    appstream
    bubblewrap
    bzip2
    curl
    dbus
    dconf
    gpgme
    json-glib
    libarchive
    libcap
    libseccomp
    xz
    zstd
    polkit
    python3
    systemd
    xorg.libXau
    fuse3
    gsettings-desktop-schemas
    glib-networking
    librsvg # for flatpak-validate-icon
  ];

  # Required by flatpak.pc
  propagatedBuildInputs = [
    glib
    ostree
  ];

  nativeCheckInputs = [
    valgrind
  ];

  # TODO: some issues with temporary files
  doCheck = false;

  NIX_LDFLAGS = "-lpthread";

  enableParallelBuilding = true;

  configureFlags = [
    "--with-curl"
    "--with-system-bubblewrap=${bubblewrap}/bin/bwrap"
    "--with-system-dbus-proxy=${xdg-dbus-proxy}/bin/xdg-dbus-proxy"
    "--with-dbus-config-dir=${placeholder "out"}/share/dbus-1/system.d"
    "--localstatedir=/var"
    "--enable-gtk-doc"
    "--enable-installed-tests"
  ];

  makeFlags = [
    "installed_testdir=${placeholder "installedTests"}/libexec/installed-tests/flatpak"
    "installed_test_metadir=${placeholder "installedTests"}/share/installed-tests/flatpak"
  ];

  postPatch = let
    vsc-py = python3.withPackages (pp: [
      pp.pyparsing
    ]);
  in ''
    patchShebangs buildutil
    patchShebangs tests
    PATH=${lib.makeBinPath [vsc-py]}:$PATH patchShebangs --build subprojects/variant-schema-compiler/variant-schema-compiler
  '';

  passthru = {
    icon-validator-patch = substituteAll {
      src = ./fix-icon-validation.patch;
      inherit (builtins) storeDir;
    };

    tests = {
      installedTests = nixosTests.installed-tests.flatpak;

      validate-icon = runCommand "test-icon-validation" { } ''
        ${finalAttrs.finalPackage}/libexec/flatpak-validate-icon --sandbox 512 512 ${../../../applications/audio/zynaddsubfx/ZynLogo.svg} > "$out"
        grep format=svg "$out"
      '';
    };
  };

  meta = with lib; {
    description = "Linux application sandboxing and distribution framework";
    homepage = "https://flatpak.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
})
