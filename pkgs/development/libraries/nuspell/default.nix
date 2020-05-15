{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, icu, catch2, ronn }:

stdenv.mkDerivation rec {
  pname = "nuspell";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    sha256 = "18zz3rdzlb3knzsd98vw8cfyb3iq0ilipnlz7rz10zgb5ail73s2";
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
