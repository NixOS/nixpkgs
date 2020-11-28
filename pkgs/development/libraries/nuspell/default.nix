{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, icu, catch2, ronn }:

stdenv.mkDerivation rec {
  pname = "nuspell";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    sha256 = "1jfnwva2i67i9pyh123a5h2zs5p7gw77qh4w7qkx61jigsyxc5v7";
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
    license = licenses.lgpl3Plus;
  };
}
