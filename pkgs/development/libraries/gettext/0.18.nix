{ stdenv, fetchurl, gettext }:

stdenv.lib.overrideDerivation gettext (attrs: rec {
  name = "gettext-0.18.2";

  src = fetchurl {
    url = "mirror://gnu/gettext/${name}.tar.gz";
    sha256 = "516a6370b3b3f46e2fc5a5e222ff5ecd76f3089bc956a7587a6e4f89de17714c";
  };

})
