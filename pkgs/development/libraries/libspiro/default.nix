{lib, stdenv, pkg-config, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libspiro";
  version = "20200505";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = pname;
    rev = version;
    sha256 = "1b5bw5qxqlral96y1n5f3sh9yxm2yij3zkqjmlgd8r1k4j0d3nqw";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  meta = with lib; {
    description = "A library that simplifies the drawing of beautiful curves";
    homepage = "https://github.com/fontforge/libspiro";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.erictapen ];
  };
}
