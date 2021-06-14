{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config }:

stdenv.mkDerivation rec {
  pname = "rlottie";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = pname;
    rev = "v${version}";
    sha256 = "10bxr1zf9wxl55d4cw2j02r6sgqln7mbxplhhfvhw0z92fi40kr3";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/Samsung/rlottie";
    description = "A platform independent standalone c++ library for rendering vector based animations and art in realtime";
    license = with licenses; [ mit bsd3 mpl11 ftl ];
    platforms = platforms.all;
    maintainers = with maintainers; [ CRTified ];
  };
}
