{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, icu, catch2, ronn }:

stdenv.mkDerivation rec {
  pname = "nuspell";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    sha256 = "0n5cajrp1fhk8p54ch3akkd9nl8b9c6wwf25980dhagcdys3vab3";
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
