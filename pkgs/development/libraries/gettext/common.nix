# gettext-runtime, gettext-tools and libtextstyle are shipped
# together. This file is a central point used to share information
# between the three package definitions.
{ fetchurl }:
rec {
  pname = "gettext";
  version = "0.20.1";

  src = fetchurl {
    url = "mirror://gnu/gettext/${pname}-${version}.tar.gz";
    sha256 = "0p3zwkk27wm2m2ccfqm57nj7vqkmfpn7ja1nf65zmhz8qqs5chb6";
  };
}
