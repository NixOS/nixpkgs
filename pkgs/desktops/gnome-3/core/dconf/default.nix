{ stdenv, fetchurl, meson, ninja, python3, vala, libxslt, pkgconfig, glib, dbus-glib, gnome3
, libxml2, docbook_xsl, makeWrapper }:

let
  pname = "dconf";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0hn7v6769xabqz7kvyb2hfm19h46z1whkair7ff752zmbs3b7lv1";
  };

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ meson ninja vala pkgconfig python3 libxslt libxml2 docbook_xsl ];
  buildInputs = [ glib dbus-glib ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/dconf;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = gnome3.maintainers;
  };
}
