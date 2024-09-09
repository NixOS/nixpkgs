{lib, stdenv, pkg-config, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libspiro";
  version = "20240902";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = pname;
    rev = version;
    sha256 = "sha256-GaLfNxL/Y0JsRXIldxliBFaB2ZLFVPR7Du8GTZ77HFo=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  meta = with lib; {
    description = "Library that simplifies the drawing of beautiful curves";
    homepage = "https://github.com/fontforge/libspiro";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.erictapen ];
  };
}
