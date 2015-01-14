{ stdenv, fetchurl, gettext }:

stdenv.lib.overrideDerivation gettext (attrs: rec {
  name = "gettext-0.19.4";

  src = fetchurl {
    url = "mirror://gnu/gettext/${name}.tar.gz";
    sha256 = "0gvz86m4cs8bdf3mwmwsyx6lrq4ydfxgadrgd9jlx32z3bnz3jca";
  };
})
