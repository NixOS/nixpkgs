{ stdenv, fetchurl, meson, ninja, python3, vala, libxslt, pkgconfig, glib, bash-completion, dbus, gnome3
, libxml2, gtk-doc, docbook_xsl, docbook_xml_dtd_42 }:

let
  pname = "dconf";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "05d72i7gj7q23qqr7zpjjinzlz84c33hrjrhx10m5v4mhg4mdwha";
  };

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  outputs = [ "out" "lib" "dev" "devdoc" ];

  nativeBuildInputs = [ meson ninja vala pkgconfig python3 libxslt libxml2 gtk-doc docbook_xsl docbook_xml_dtd_42 ];
  buildInputs = [ glib bash-completion dbus ];

  mesonFlags = [
    "--sysconfdir=/etc"
    "-Dgtk_doc=true"
  ];

  doCheck = true;

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
