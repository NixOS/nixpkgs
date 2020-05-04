{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, icu, catch2, ronn }:

stdenv.mkDerivation rec {
  pname = "nuspell";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    sha256 = "19mwjg5mz645i4ijhx93rqbcim14ca6nczymr20p0z0pn5mx5p18";
  };

  nativeBuildInputs = [ cmake pkgconfig ronn ];
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
  };
}
