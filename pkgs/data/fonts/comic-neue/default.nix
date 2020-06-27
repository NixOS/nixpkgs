{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "comic-neue";
  version = "2.3";

  src = fetchzip {
    url = "https://comicneue.com/${pname}-${version}.zip";
    sha256 = "1d8hgd045bj0aswd9lis1mb8vfnkknvnpskmg229vrf3rc6cq5zm";
    stripRoot = false;
  };

  meta = with lib; {
    homepage = "https://comicneue.com/";
    description = "A casual type face: Make your lemonade stand look like a fortune 500 company";
    longDescription = ''
      It is inspired by Comic Sans but more regular.  The font was
      designed by Craig Rozynski.  It is available in two variants:
      Comic Neue and Comic Neue Angular.  The former having round and
      the latter angular terminals.  Both variants come in Light,
      Regular, and Bold weights with Oblique variants.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
