{ stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "cldr-emoji-annotation";
  version = "36.12.120200305_0";

  src = fetchFromGitHub {
    owner = "fujiwarat";
    repo = "cldr-emoji-annotation";
    rev = version;
    sha256 = "1zg4czaqnfjkd4hx06h8q56z8iiw22crwqr69w94s4hy9zcanfrs";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with stdenv.lib; {
    description = "Emoji annotation files in CLDR";
    homepage = "https://www.unicode.org/";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
  };
}
