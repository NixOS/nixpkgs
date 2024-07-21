{ lib, stdenv, fetchFromGitLab, pkg-config, meson, ninja, glib, glib-networking
, sqlite, gobject-introspection, vala, gtk-doc, libsecret, docbook_xsl
, docbook_xml_dtd_43, docbook_xml_dtd_45, glibcLocales, makeWrapper
, symlinkJoin, gsignondPlugins, plugins }:

let
unwrapped = stdenv.mkDerivation rec {
  pname = "gsignond";
  version = "1.2.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = pname;
    rev = version;
    sha256 = "17cpil3lpijgyj2z5c41vhb7fpk17038k5ggyw9p6049jrlf423m";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook_xml_dtd_45
    docbook_xsl
    glibcLocales
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    glib-networking
    libsecret
  ];

  propagatedBuildInputs = [ sqlite ];

  mesonFlags = [
    "-Dbus_type=session"
    "-Dextension=desktop"
  ];

  LC_ALL = "en_US.UTF-8";

  patches = [
    ./conf.patch
    ./plugin-load-env.patch
  ];

  meta = with lib; {
    description = "D-Bus service which performs user authentication on behalf of its clients";
    mainProgram = "gsignond";
    homepage = "https://gitlab.com/accounts-sso/gsignond";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
};

in if plugins == [] then unwrapped
    else import ./wrapper.nix {
      inherit makeWrapper symlinkJoin plugins;
      gsignond = unwrapped;
    }

