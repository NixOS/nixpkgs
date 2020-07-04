{ fetchFromGitHub
, cinnamon-desktop
, cinnamon-settings-daemon
, dbus-glib
, docbook_xsl
, docbook_xml_dtd_412
, glib
, gsettings-desktop-schemas
, gtk3
, libcanberra
, libxslt
, makeWrapper
, meson
, ninja
, pkgconfig
, python3
, stdenv
, systemd
, wrapGAppsHook
, xapps
, xmlto
, xorg
, cmake
, libexecinfo
, pango
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-session";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "1bkhzgdinsk4ahp1b4jf50phxwv2da23rh35cmg9fbm5c88701ga";
  };

  patches = [
    ./0001-Add-dbus_glib-dependency.patch
  ];

  buildInputs = [
    # meson.build
    gtk3
    glib
    libcanberra
    pango
    xorg.libX11
    xorg.libXext
    xapps
    xorg.libXau
    xorg.libXcomposite

    systemd

    xorg.libXtst
    xorg.libXrender
    xorg.xtrans

    # other (not meson.build)

    cinnamon-desktop
    cinnamon-settings-daemon
    dbus-glib
    glib
    gsettings-desktop-schemas
  ];

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook
    libexecinfo
    docbook_xsl
    docbook_xml_dtd_412
    python3
    pkgconfig
    libxslt
    xmlto
  ];

  # TODO: https://github.com/NixOS/nixpkgs/issues/36468
  mesonFlags = [ "-Dc_args=-I${glib.dev}/include/gio-unix-2.0" "-Dgconf=false" "-DENABLE_IPV6=true" ];

  postPatch = ''
    chmod +x data/meson_install_schemas.py # patchShebangs requires executable file
    patchShebangs data/meson_install_schemas.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${cinnamon-desktop}/share"
      --prefix XDG_CONFIG_DIRS : "${cinnamon-settings-daemon}/etc/xdg"
    )
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon-session";
    description = "The Cinnamon session manager";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
