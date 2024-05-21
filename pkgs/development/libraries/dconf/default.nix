{ lib, stdenv
, fetchurl
, meson
, mesonEmulatorHook
, ninja
, python3
, vala
, libxslt
, pkg-config
, glib
, bash-completion
, dbus
, gnome
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_42
, withDocs ? true
}:

stdenv.mkDerivation rec {
  pname = "dconf";
  version = "0.40.0";

  outputs = [ "out" "lib" "dev" ]
    ++ lib.optional withDocs "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0cs5nayg080y8pb9b7qccm1ni8wkicdmqp1jsgc22110r6j24zyg";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    libxslt
    glib
    docbook-xsl-nons
    docbook_xml_dtd_42
    gtk-doc
  ] ++ lib.optionals (withDocs && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook  # gtkdoc invokes the host binary to produce documentation
  ];


  buildInputs = [
    glib
    bash-completion
    dbus
    vala
  ];

  mesonFlags = [
    "--sysconfdir=/etc"
    "-Dgtk_doc=${lib.boolToString withDocs}"
  ];

  nativeCheckInputs = [
    dbus # for dbus-daemon
  ];

  doCheck = !stdenv.isAarch32 && !stdenv.isAarch64 && !stdenv.isDarwin;

  postPatch = ''
    chmod +x meson_post_install.py tests/test-dconf.py
    patchShebangs meson_post_install.py
    patchShebangs tests/test-dconf.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/dconf";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
    mainProgram = "dconf";
  };
}
