{ stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "cldr-emoji-annotation";
  version = "37.0_13.0_0_1";

  src = fetchFromGitHub {
    owner = "fujiwarat";
    repo = "cldr-emoji-annotation";
    rev = version;
    sha256 = "19cqxyrap3p7djzzs99pndjbcvzmdv86n2m1sw2zqiwpirw7y1sy";
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
