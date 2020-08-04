{ stdenv
, fetchurl
, fetchpatch
, autoconf
, automake
, libtool
, docbook_xml_dtd_412
, docbook_xml_dtd_42
, docbook_xml_dtd_43
, docbook-xsl-nons
, which
, libxml2
, gobject-introspection
, gtk-doc
, intltool
, libxslt
, pkg-config
, xmlto
, appstream-glib
, substituteAll
, yacc
, xdg-dbus-proxy
, p11-kit
, bubblewrap
, bzip2
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
, fuse
, nixosTests
, libsoup
, lzma
, zstd
, ostree
, polkit
, python3
, systemd
, xorg
, valgrind
, glib-networking
, wrapGAppsHook
, dconf
, gsettings-desktop-schemas
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "flatpak";
  version = "1.8.1";

  # TODO: split out lib once we figure out what to do with triggerdir
  outputs = [ "out" "dev" "man" "doc" "devdoc" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "ZpFLZvmmQHk4bMCXpAoZ+oQZVo33+0VvLkB/D3asnq0=";
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
      p11kit = "${p11-kit.dev}/bin/p11-kit";
    })

    # Adapt paths exposed to sandbox for NixOS.
    (substituteAll {
      src = ./bubblewrap-paths.patch;
      inherit (builtins) storeDir;
    })

    # Allow gtk-doc to find schemas using XML_CATALOG_FILES environment variable.
    # Patch taken from gtk-doc expression.
    ./respect-xml-catalog-files-var.patch

    # Don’t hardcode flatpak binary path in launchers stored under user’s profile otherwise they will break after Flatpak update.
    # https://github.com/NixOS/nixpkgs/issues/43581
    ./use-flatpak-from-path.patch

    # Nix environment hacks should not leak into the apps.
    # https://github.com/NixOS/nixpkgs/issues/53441
    ./unset-env-vars.patch

    # But we want the GDK_PIXBUF_MODULE_FILE from the wrapper affect the icon validator.
    ./validate-icon-pixbuf.patch

    # Fix `flatpak/test-oci-registry@{user,system}.wrap.test` installed tests.
    # https://github.com/flatpak/flatpak/pull/3762
    (fetchpatch {
      url = "https://github.com/flatpak/flatpak/commit/c1447dadecd50f384b6d11dac18b014245267d00.patch";
      sha256 = "UAA/wGr8/aMbx5MV+8Ilro2kgKkx2QOn88lDUjCgeDA=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    libxml2
    # TODO: replace with docbook_xml_dtd_45 https://github.com/flatpak/flatpak/pull/3760
    docbook_xml_dtd_412
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook-xsl-nons
    which
    gobject-introspection
    gtk-doc
    intltool
    libxslt
    pkg-config
    xmlto
    appstream-glib
    yacc
    wrapGAppsHook
  ];

  buildInputs = [
    bubblewrap
    bzip2
    dbus
    dconf
    gpgme
    json-glib
    libarchive
    libcap
    libseccomp
    libsoup
    lzma
    # zstd # TODO: broken paths in .pc file
    polkit
    python3
    systemd
    xorg.libXau
    fuse
    gsettings-desktop-schemas
    glib-networking
    librsvg # for flatpak-validate-icon
  ];

  # Required by flatpak.pc
  propagatedBuildInputs = [
    glib
    ostree
  ];

  checkInputs = [
    valgrind
  ];

  # TODO: some issues with temporary files
  doCheck = false;

  NIX_LDFLAGS = "-lpthread";

  enableParallelBuilding = true;

  configureFlags = [
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
    PATH=${stdenv.lib.makeBinPath [vsc-py]}:$PATH patchShebangs --build variant-schema-compiler/variant-schema-compiler
  '';

  preConfigure = ''
    # TODO: remove the condition once autogen.sh is shipped in the tarball
    # https://github.com/flatpak/flatpak/pull/3761
    if [[ -f autogen.sh ]]; then
        NOCONFIGURE=1 ./autogen.sh
    else
        autoreconf --install --force --verbose
    fi
  '';

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.flatpak;
    };
  };

  meta = with stdenv.lib; {
    description = "Linux application sandboxing and distribution framework";
    homepage = "https://flatpak.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
