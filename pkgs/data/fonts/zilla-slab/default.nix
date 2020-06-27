{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "zilla-slab";
  version = "1.002";

  src = fetchzip {
    url = "https://github.com/mozilla/zilla-slab/releases/download/v${version}/Zilla-Slab-Fonts-v${version}.zip";
    sha256 = "09q4dakx9hl0jn0b5n983fk4a7gm0ghvaxakqcxj55wnskwyxqf8";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://github.com/mozilla/zilla-slab";
    description = "Zilla Slab fonts";
    longDescription = ''
      Zilla Slab is Mozilla's core typeface, used
      for the Mozilla wordmark, headlines and
      throughout their designs. A contemporary
      slab serif, based on Typotheque's Tesla, it
      is constructed with smooth curves and true
      italics, which gives text an unexpectedly
      sophisticated industrial look and a friendly
      approachability in all weights.
    '';
    license = licenses.ofl;
    maintainers = with maintainers; [ caugner ];
    platforms = platforms.all;
  };
}
