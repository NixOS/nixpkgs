{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, glib
, pcre2
, gtk4
, pango
, fribidi
, vala
, gi-docgen
, libxml2
, perl
, gettext
, gnome
, gobject-introspection
, dbus
, xvfb-run
, shared-mime-info
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtksourceview";
  version = "5.14.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/${lib.versions.majorMinor finalAttrs.version}/gtksourceview-${finalAttrs.version}.tar.xz";
    hash = "sha256-AJhi6HuSnaWnJOzgefAfjO4p50eXoeysNJ9YwVo8vFg=";
  };

  patches = [
    # By default, the library loads syntaxes from XDG_DATA_DIRS and user directory
    # but not from its own datadr (it assumes it will be in XDG_DATA_DIRS).
    # Since this is not generally true with Nix, let’s add $out/share unconditionally.
    ./4.x-nix_share_path.patch
  ];

  # The 10.12 SDK used by x86_64-darwin requires defining `_POSIX_C_SOURCE` to use `strnlen`.
  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) "-D_POSIX_C_SOURCE=200809L";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    perl
    gobject-introspection
    vala
    gi-docgen
    gtk4 # for gtk4-update-icon-cache checked during configure
  ];

  buildInputs = [
    glib
    pcre2
    pango
    fribidi
    libxml2
  ];

  propagatedBuildInputs = [
    # Required by gtksourceview-5.0.pc
    gtk4
    # Used by gtk_source_language_manager_guess_language
    shared-mime-info
  ];

  nativeCheckInputs = [
    xvfb-run
    dbus
  ];

  mesonFlags = [
    "-Ddocumentation=true"
  ];

  doCheck = stdenv.hostPlatform.isLinux;

  checkPhase = ''
    runHook preCheck

    env \
      XDG_DATA_DIRS="$XDG_DATA_DIRS:${shared-mime-info}/share" \
      GTK_A11Y=none \
      xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
        --config-file=${dbus}/share/dbus-1/session.conf \
        meson test --no-rebuild --print-errorlogs

    runHook postCheck
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gtksourceview";
      attrPath = "gtksourceview5";
      versionPolicy = "odd-unstable";
    };
  };

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Source code editing widget for GTK";
    homepage = "https://gitlab.gnome.org/GNOME/gtksourceview";
    pkgConfigModules = [ "gtksourceview-5" ];
    platforms = platforms.unix;
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
  };
})
