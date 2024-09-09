{ lib, fetchFromGitHub, mkDerivation
, cmake, extra-cmake-modules
, qtbase, kcoreaddons, kdecoration
}:

mkDerivation rec {
  pname = "kde2-decoration";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "repos-holder";
    repo = "kdecoration2-kde2";
    rev = version;
    sha256 = "y2q1j36EURJc7k1huqhEH1Z82PnVSKlfx20bpQWY28c=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ qtbase kcoreaddons kdecoration ];

  meta = with lib; {
    description = "KDE 2 window decoration ported to Plasma 5";
    homepage = "https://github.com/repos-holder/kdecoration2-kde2";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
