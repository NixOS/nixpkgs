{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "crimson";
  version = "2014.10";

  src = fetchzip {
    url = "https://github.com/skosch/Crimson/archive/fonts-october2014.tar.gz";
    sha256 = "00b8gpfp31fb9bqpzlaql6vb82gnhy43zx0amik39pdxpbplp7ss";
  };

  meta = with lib; {
    homepage = "https://aldusleaf.org/crimson.html";
    description = "A font family inspired by beautiful oldstyle typefaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
