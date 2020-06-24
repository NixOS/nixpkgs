{ lib, mkFont, fetchzip }:

mkFont {
  pname = "cooper-hewitt";
  version = "2014-06-09";

  src = fetchzip {
    url = "https://www.cooperhewitt.org/wp-content/uploads/fonts/CooperHewitt-OTF-public.zip";
    sha256 = "1gamnypkfzv16np8aa8jnw38v84z944bspbkpqlxnd4q0xfl8fbd";
  };

  meta = with lib; {
    homepage = "https://www.cooperhewitt.org/open-source-at-cooper-hewitt/cooper-hewitt-the-typeface-by-chester-jenkins/";
    description = "A contemporary sans serif, with characters composed of modified-geometric curves and arches";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
