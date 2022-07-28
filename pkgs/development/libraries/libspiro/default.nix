{lib, stdenv, pkg-config, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libspiro";
  version = "20220722";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = pname;
    rev = version;
    sha256 = "sha256-qNff53wyf8YhFVOn169K7smCXrSxdiZWxWOU8VTcjSI=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  meta = with lib; {
    description = "A library that simplifies the drawing of beautiful curves";
    homepage = "https://github.com/fontforge/libspiro";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.erictapen ];
  };
}
