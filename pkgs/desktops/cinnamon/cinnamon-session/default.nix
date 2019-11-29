{ cinnamon-desktop, cinnamon-settings-daemon, dbus-glib, docbook_xsl, docbook_xml_dtd_412, fetchFromGitHub, glib, gsettings-desktop-schemas, gtk3, libcanberra, libxslt, makeWrapper, meson, ninja, pkgconfig, python3, stdenv, systemd, wrapGAppsHook, xapps, xmlto, xorg, gnome2, cmake, libexecinfo }:

stdenv.mkDerivation rec {
  pname = "cinnamon-session";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0hplck17rksfgqm2z58ajvz4p2m4zg6ksdpbc27ki20iv4fv620s";
  };

  /* Run-time dependency libelogind found: NO (tried pkgconfig and cmake)
  Run-time dependency libsystemd-login found: NO (tried pkgconfig and cmake)
  Run-time dependency libsystemd found: NO (tried pkgconfig and cmake) */

  buildInputs = [ cinnamon-desktop cinnamon-settings-daemon dbus-glib glib gsettings-desktop-schemas gtk3 libcanberra libxslt makeWrapper pkgconfig xapps xmlto xorg.xtrans xorg.libXtst gnome2.GConf systemd ];
  nativeBuildInputs = [ meson ninja wrapGAppsHook cmake libexecinfo docbook_xsl docbook_xml_dtd_412 python3 ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";  # TODO: https://github.com/NixOS/nixpkgs/issues/36468
  configureFlags = [ "--enable-systemd" ];

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

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon-session";
    description = "The Cinnamon session manager" ;

    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
