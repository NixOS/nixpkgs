{ lib, fetchFromGitHub, mkDerivation
, cmake, extra-cmake-modules
, qtbase, kcoreaddons, kdecoration
}:

mkDerivation rec {
  pname = "kde2-decoration";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "repos-holder";
    repo = "kdecoration2-kde2";
    rev = version;
    sha256 = "1766z9wscybcqvr828xih93b3rab3hb0ghsf818iflhp1xy0js08";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ qtbase kcoreaddons kdecoration ];

  meta = with lib; {
    description = "KDE 2 window decoration ported to Plasma 5";
    homepage = "https://github.com/repos-holder/kdecoration2-kde2";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
