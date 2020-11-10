{stdenv, fetchurl, pkgconfig, perlPackages, libxml2, libxslt, docbook_xml_dtd_42, gnome3}:
let
  pname = "rarian";
  version = "0.8.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.gz";
    sha256 = "aafe886d46e467eb3414e91fa9e42955bd4b618c3e19c42c773026b205a84577";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 libxslt ]
    ++ (with perlPackages; [ perl XMLParser ]);
  configureFlags = [ "--with-xml-catalog=${docbook_xml_dtd_42}/xml/dtd/docbook/docbook.cat" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Documentation metadata library based on the proposed Freedesktop.org spec";
    homepage = "https://rarian.freedesktop.org/";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
