{ stdenv, fetchurl, meson, ninja, python3, vala, libxslt, pkgconfig, glib, bash-completion, dbus, gnome3
, libxml2, gtk-doc, docbook_xsl, docbook_xml_dtd_42, fetchpatch }:

let
  pname = "dconf";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1azz4hb9z76yxn34yrrsiib3iqz5z4vpwn5q7cncp55w365ygg38";
  };

  patches = [
    # Fix the build on Darwin
    # Issue: https://gitlab.gnome.org/GNOME/dconf/issues/47
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/dconf/commit/49f4d916e1151af3975df52c522c69de98ed2fbb.patch";
      sha256 = "00klkr1jzli9ap0aj6399m1bj2bxxz48pmcj4r16dsy6dfdl6325";
    })
  ];

  postPatch = ''
    chmod +x meson_post_install.py tests/test-dconf.py
    patchShebangs meson_post_install.py
    patchShebangs tests/test-dconf.py
  '';

  outputs = [ "out" "lib" "dev" "devdoc" ];

  nativeBuildInputs = [ meson ninja vala pkgconfig python3 libxslt libxml2 gtk-doc docbook_xsl docbook_xml_dtd_42 ];
  buildInputs = [ glib bash-completion dbus ];

  mesonFlags = [
    "--sysconfdir=/etc"
    "-Dgtk_doc=true"
  ];

  doCheck = !stdenv.isAarch64;

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
