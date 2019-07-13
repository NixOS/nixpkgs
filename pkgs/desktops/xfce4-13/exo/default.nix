{ mkXfceDerivation, docbook_xsl, libxslt, perlPackages, gtk3
, libxfce4ui, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "exo";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "0s91fv4yzafmdi25c63yin15sa25cfcyarpvavr4q3mmmiamzpi0";

  nativeBuildInputs = [ libxslt perlPackages.URI ];
  buildInputs = [ gtk3 libxfce4ui libxfce4util ];

  postPatch = ''
    substituteInPlace exo-helper/Makefile.am \
      --replace 'exo_helper_2_CFLAGS =' \
                'exo_helper_2_CFLAGS = $(GIO_UNIX_CFLAGS)'

    substituteInPlace docs/reference/Makefile.am \
      --replace http://docbook.sourceforge.net/release/xsl/current \
                ${docbook_xsl}/share/xml/docbook-xsl
  '';

  meta = {
    description = "Application library for Xfce";
  };
}
