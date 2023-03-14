{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "sfsexp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "mjsottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TCAxofSRbyIdwowhHhPn483UA+QOHkLMz0P2LIi0ncA=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Small Fast S-Expression Library";
    homepage = "https://github.com/mjsottile/sfsexp";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
