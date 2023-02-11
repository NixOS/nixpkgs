{ lib, stdenv
, fetchurl
, meson
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
}:
let
  isCross = (stdenv.hostPlatform != stdenv.buildPlatform);
in
stdenv.mkDerivation rec {
  pname = "dconf";
  version = "0.40.0";

  outputs = [ "out" "lib" "dev" ]
    ++ lib.optional (!isCross) "devdoc";

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
  ] ++ lib.optional (!isCross) gtk-doc;

  buildInputs = [
    glib
    bash-completion
    dbus
  ] ++ lib.optional (!isCross) vala;
  # Vala cross compilation is broken. For now, build dconf without vapi when cross-compiling.

  mesonFlags = [
    "--sysconfdir=/etc"
    "-Dgtk_doc=${lib.boolToString (!isCross)}" # gtk-doc does do some gobject introspection, which doesn't yet cross-compile.
  ] ++ lib.optional isCross "-Dvapi=false";

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
    homepage = "https://wiki.gnome.org/Projects/dconf";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
