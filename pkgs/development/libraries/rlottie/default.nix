{ stdenv, fetchFromGitHub, meson, ninja, pkg-config }:

stdenv.mkDerivation rec {
  pname = "rlottie";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8KQ0ZnVg5rTb44IYnn02WBSe2SA5UGUOSLEdmmscUDs=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Samsung/rlottie";
    description = "A platform independent standalone c++ library for rendering vector based animations and art in realtime";
    license = licenses.unfree; # Mixed, see https://github.com/Samsung/rlottie/blob/master/COPYING
    platforms = platforms.all;
    maintainers = with maintainers; [ CRTified ];
  };
}
