{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "liberastika";
  version = "1.1.5";

  src = fetchzip {
    url = "mirror://sourceforge/project/lib-ka/liberastika-ttf-${version}.zip";
    sha256 = "0gg7fabnpybkqihjd07l30wkgjs56b0jgjmkqf2ag3v1dhx2k1f2";
    stripRoot = false;
  };

  meta = with lib; {
    description = "Liberation Sans fork with improved cyrillic support";
    homepage = "https://sourceforge.net/projects/lib-ka/";

    license = licenses.gpl2;
    platforms = platforms.all;
    hydraPlatforms = [];
    maintainers = [ maintainers.volth ];
  };
}
