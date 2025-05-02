{ stdenv
, lib
, fetchurl
, pkg-config
, meson
, ninja
, glib
, gnome
, gettext
, gobject-introspection
, vala
, sqlite
, dbus-glib
, dbus
, libgee
, evolution-data-server-gtk4
, python3
, readline
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_43
, telepathy-glib
, telepathySupport ? false
}:

# TODO: enable more folks backends

stdenv.mkDerivation (finalAttrs: {
  pname = "folks";
  version = "0.15.9";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/folks/${lib.versions.majorMinor finalAttrs.version}/folks-${finalAttrs.version}.tar.xz";
    hash = "sha256-IxGzc1XDUfM/Fj/cOUh0oioKBoLDGUk9bYpuQgcRQV8=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    meson
    ninja
    pkg-config
    vala
  ] ++ lib.optionals telepathySupport [
    python3
  ];

  buildInputs = [
    dbus-glib
    evolution-data-server-gtk4 # UI part not needed, using gtk4 version to reduce system closure.
    readline
  ] ++ lib.optionals telepathySupport [
    telepathy-glib
  ];

  propagatedBuildInputs = [
    glib
    libgee
    sqlite
  ];

  nativeCheckInputs = [
    dbus
    (python3.withPackages (pp: with pp; [
      python-dbusmock
      # The following possibly need to be propagated by dbusmock
      # if they are not optional
      dbus-python
      pygobject3
    ]))
  ];

  mesonFlags = [
    "-Ddocs=true"
    "-Dtelepathy_backend=${lib.boolToString telepathySupport}"
    "-Dtests=${lib.boolToString (finalAttrs.doCheck && stdenv.isLinux)}"
  ];

  # backends/eds/lib/libfolks-eds.so.26.0.0.p/edsf-persona-store.c:10697:4:
  # error: call to undeclared function 'folks_persona_store_set_is_user_set_default';
  # ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";

  # Checks last re-enabled in https://github.com/NixOS/nixpkgs/pull/279843, but timeouts in tests still
  # occur inconsistently
  doCheck = false;

  # Prevents e-d-s add-contacts-stress-test from timing out
  checkPhase = ''
    runHook preCheck
    meson test --timeout-multiplier 4
    runHook postCheck
  '';

  postPatch = lib.optionalString telepathySupport ''
    patchShebangs tests/tools/manager-file.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "folks";
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "A library that aggregates people from multiple sources to create metacontacts";
    homepage = "https://gitlab.gnome.org/GNOME/folks";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
})
