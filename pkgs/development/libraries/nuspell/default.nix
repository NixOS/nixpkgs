{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, icu, catch2 }:

stdenv.mkDerivation rec {
  name = "nuspell-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
    sha256 = "17khkb1sxn1p6rfql72l7a4lxafbxj0dwi95hsmyi6wajvfrg9sy";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ boost icu ];

  enableParallelBuilding = true;

  postPatch = ''
    rm -rf external/Catch2
    ln -sf ${catch2.src} external/Catch2
  '';

  meta = with stdenv.lib; {
    description = "Free and open source C++ spell checking library";
    homepage = "https://nuspell.github.io/";
    maintainers = with maintainers; [ fpletz ];
  };
}
