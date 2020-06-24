{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "wqy-microhei";
  version = "0.2.0-beta";

  src = fetchzip {
    url = "mirror://sourceforge/wqy/${pname}-${version}.tar.gz";
    sha256 = "15g5acz29yk1kv8167h1bf71ixycql0dwgxxsincx448fpd2hkym";
  };

  meta = {
    description = "A (mainly) Chinese Unicode font";
    homepage = "http://wenq.org";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.pkmx ];
    platforms = lib.platforms.all;
  };
}

