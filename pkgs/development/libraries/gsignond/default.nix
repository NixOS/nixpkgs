{ stdenv, fetchFromGitLab, pkgconfig, meson, ninja, glib, glib-networking
, sqlite, gobjectIntrospection, vala, gtk-doc, libsecret, docbook_xsl
, docbook_xml_dtd_43, docbook_xml_dtd_45, glibcLocales, makeWrapper
, symlinkJoin, gsignondPlugins, plugins }:

let
unwrapped = stdenv.mkDerivation rec {
  pname = "gsignond";
  version = "39022c86ddb5062a10fb0503ad9d81a8e532d527";

  name = "${pname}-2018-10-04";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = pname;
    rev = version;
    sha256 = "1gw8vbj3j6wxqy759z97arm8lnqhmraw9s2frv3ar6crnfhlidff";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook_xml_dtd_45
    docbook_xsl
    glibcLocales
    gobjectIntrospection
    gtk-doc
    meson
    ninja
    pkgconfig
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

  meta = with stdenv.lib; {
    description = "D-Bus service which performs user authentication on behalf of its clients";
    homepage = https://gitlab.com/accounts-sso/gsignond;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
};

in if plugins == [] then unwrapped
    else import ./wrapper.nix {
      inherit stdenv makeWrapper symlinkJoin gsignondPlugins plugins;
      gsignond = unwrapped;
    }

