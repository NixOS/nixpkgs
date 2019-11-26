{ cinnamon-desktop, cinnamon-settings-daemon, dbus-glib, docbook_xsl, docbook_xml_dtd_412, fetchFromGitHub, gconf, glib, gsettings_desktop_schemas, gtk3, libcanberra, libxslt, makeWrapper, meson, ninja, pkgconfig, python3, stdenv, systemd, wrapGAppsHook, xapps, xmlto, xorg }:

stdenv.mkDerivation rec {
  pname = "cinnamon-session";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-session";
    rev = "${version}";
    sha256 = "1jrwjnrcmp5m9vlp42ql79bxic5nrs37kkgcvgyhvvvskvdwpyfw";
  };

  buildInputs = [ cinnamon-desktop cinnamon-settings-daemon dbus-glib docbook_xsl docbook_xml_dtd_412 gconf glib gsettings_desktop_schemas gtk3 libcanberra libxslt makeWrapper pkgconfig python3 xapps xmlto xorg.xtrans ];
  nativeBuildInputs = [ meson ninja wrapGAppsHook ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";
  configureFlags = "--enable-systemd";

  postPatch = ''
    chmod +x data/meson_install_schemas.py # patchShebangs requires executable file
    patchShebangs data/meson_install_schemas.py

    substituteInPlace cinnamon-session/meson.build \
      --replace "# elogind" "dbus_glib"

    sed -i "51i dbus_glib = dependency('dbus-glib-1')" meson.build
  '';

  postFixUp = ''
    for f in "$out/bin/"*; do
      wrapProgram "$f" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
        --suffix XDG_DATA_DIRS : "${cinnamon-desktop}/share" \
        --suffix XDG_DATA_DIRS : "${cinnamon-settings-daemon}/etc/xdg"
    done
  '';
}
