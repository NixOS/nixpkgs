{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "marathi-cursive";
  version = "2.0";

  src = fetchzip {
    url = "https://github.com/MihailJP/MarathiCursive/releases/download/v${version}/MarathiCursive-${version}.tar.xz";
    sha256 = "10vzn1lzlsd0yg3ma7h9l74ypg8m411c7arsgv4f8wpyn0qpv6xn";
  };

  meta = with lib; {
    homepage = "https://github.com/MihailJP/MarathiCursive";
    description = "Modi script font with Graphite and OpenType support";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.mit; # It's the M+ license, M+ is MIT(-ish)
    platforms = platforms.all;
  };
}
