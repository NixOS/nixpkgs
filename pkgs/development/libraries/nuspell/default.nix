{ stdenv, fetchFromGitHub, cmake, pkgconfig, icu, catch2, pandoc }:

stdenv.mkDerivation rec {
  pname = "nuspell";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    sha256 = "sha256-sQ3Q2+FOf2bXCKcgd6XvEb+QZzzDccs/4+CpJbEd1PQ=";
  };

  nativeBuildInputs = [ cmake pkgconfig pandoc ];
  buildInputs = [ icu ];

  outputs = [ "out" "lib" "dev" "man" ];

  enableParallelBuilding = true;

  postPatch = ''
    rm -rf external/Catch2
    ln -sf ${catch2.src} external/Catch2
  '';

  postInstall = ''
    rm -rf $out/share/doc
  '';

  meta = with stdenv.lib; {
    description = "Free and open source C++ spell checking library";
    homepage = "https://nuspell.github.io/";
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.lgpl3Plus;
  };
}
