{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "kawkab-mono";
  version = "0.1";

  src = fetchzip {
    url = "http://makkuk.com/kawkab-mono/downloads/${pname}-${version}.zip";
    sha256 = "0pl3wpgv0q10yshzhm0qxf28v8rm8sapjxv1w53aw1gvg36m7dka";
    stripRoot = false;
  };

  meta = {
    description = "An arab fixed-width font";
    homepage = "https://makkuk.com/kawkab-mono/";
    license = lib.licenses.ofl;
  };
}


