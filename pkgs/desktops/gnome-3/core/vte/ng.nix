{ gnome3, fetchFromGitHub, autoconf, automake, gtk_doc, gettext, libtool, gperf }:

gnome3.vte.overrideAttrs (oldAttrs: rec {
  name = "vte-ng-${version}";
  version = "0.50.2.a";

  src = fetchFromGitHub {
    owner = "thestinger";
    repo = "vte-ng";
    rev = version;
    sha256 = "0i6hfzw9sq8521kz0l7lld2km56r0bfp1hw6kxq3j1msb8z8svcf";
  };

  preConfigure = oldAttrs.preConfigure + "; NOCONFIGURE=1 ./autogen.sh";

  nativeBuildInputs = oldAttrs.nativeBuildInputs or []
    ++ [ gtk_doc autoconf automake gettext libtool gperf ];
})
