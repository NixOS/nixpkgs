{ mkXfceDerivation, docbook_xsl, libxslt, perlPackages, gtk3
, libxfce4ui, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "exo";
  version = "0.12.8";

  sha256 = "013am7q4pwfncf4hk2a3hv7yx2vxgzb5xm8qsi9mxkj29xdhrvs5";

  nativeBuildInputs = [ libxslt perlPackages.URI docbook_xsl ];
  buildInputs = [ gtk3 libxfce4ui libxfce4util ];

  postPatch = ''
    substituteInPlace exo-helper/Makefile.am \
      --replace 'exo_helper_2_CFLAGS =' \
                'exo_helper_2_CFLAGS = $(GIO_UNIX_CFLAGS)'
  '';

  meta = {
    description = "Application library for Xfce";
  };
}
