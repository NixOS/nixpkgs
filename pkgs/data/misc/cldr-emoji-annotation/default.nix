{ stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "cldr-emoji-annotation";
  version = "36.12.120191002_0";

  src = fetchFromGitHub {
    owner = "fujiwarat";
    repo = "cldr-emoji-annotation";
    rev = version;
    sha256 = "0nxigzs3mxjgi7c8mmdaxsy5sfl7ihsc2nysaj0db198b33w9clw";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with stdenv.lib; {
    description = "Emoji annotation files in CLDR";
    homepage = "https://www.unicode.org/";
    license = licenses.free; # https://www.unicode.org/license.html
    platforms = platforms.all;
  };
}
