{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "cldr-emoji-annotation";
  version = "37.0_13.0_0_2";

  src = fetchFromGitHub {
    owner = "fujiwarat";
    repo = "cldr-emoji-annotation";
    rev = version;
    sha256 = "0la3h6l58j9jfjvzwz65x56ijx7sppirwpqbqc06if4c2g0kzswj";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    description = "Emoji annotation files in CLDR";
    homepage = "https://www.unicode.org/";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
  };
}
