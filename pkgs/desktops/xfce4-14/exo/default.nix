{ mkXfceDerivation, docbook_xsl, glib, libxslt, perlPackages, gtk3
, libxfce4ui, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "exo";
  version = "0.12.8";

  sha256 = "013am7q4pwfncf4hk2a3hv7yx2vxgzb5xm8qsi9mxkj29xdhrvs5";

  nativeBuildInputs = [ libxslt perlPackages.URI docbook_xsl ];
  buildInputs = [ gtk3 glib libxfce4ui libxfce4util ];

  # Workaround https://bugzilla.xfce.org/show_bug.cgi?id=15825
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = {
    description = "Application library for Xfce";
  };
}
