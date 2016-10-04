fetchurl: rec {
  major = "1.8";
  minor = "0";
  name = "tracker-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/tracker/${major}/${name}.tar.xz";
    sha256 = "0zchaahk4w7dwanqk1vx0qgnyrlzlp81krwawfx3mv5zffik27x1";
  };

}
