{
  lib,
  stdenv,
  fetchFromGitHub,
  sqlite,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libchewing";
  version = "unstable-2020-06-27";

  src = fetchFromGitHub {
    owner = "chewing";
    repo = "libchewing";
    rev = "452f6221fbad90c0706a3963b17e226216e40dd7";
    sha256 = "sha256-w3/K2O/CU+XVzqzVCYJyq1vLgToN6iIUhJ9J7ia4p9E=";
  };

  buildInputs = [ sqlite ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Intelligent Chinese phonetic input method";
    homepage = "https://chewing.im/";
    license = licenses.lgpl21Only;
    maintainers = [ maintainers.ericsagnes ];
    platforms = platforms.linux;
  };
}
