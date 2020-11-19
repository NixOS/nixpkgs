{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, icu, catch2, pandoc }:

stdenv.mkDerivation rec {
  pname = "nuspell";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    sha256 = "1p90a3wv4b8m5fdpbnr9cyd1x3a504q9rc4cghq02xff63h5gclf";
  };

  nativeBuildInputs = [ cmake pkgconfig pandoc ];
  buildInputs = [ boost icu ];

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
    maintainers = with maintainers; [ fpletz ];
    license = licenses.lgpl3Plus;
  };
}
