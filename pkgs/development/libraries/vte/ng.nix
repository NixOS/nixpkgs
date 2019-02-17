{ vte, fetchFromGitHub, autoconf, automake, gtk-doc, gettext, libtool, gperf }:

vte.overrideAttrs (oldAttrs: rec {
  name = "vte-ng-${version}";
  version = "0.54.2.a";

  src = fetchFromGitHub {
    owner = "thestinger";
    repo = "vte-ng";
    rev = version;
    sha256 = "1r7d9m07cpdr4f7rw3yx33hmp4jmsk0dn5byq5wgksb2qjbc4ags";
  };

  preConfigure = oldAttrs.preConfigure + "; NOCONFIGURE=1 ./autogen.sh";

  nativeBuildInputs = oldAttrs.nativeBuildInputs or []
    ++ [ gtk-doc autoconf automake gettext libtool gperf ];
})
