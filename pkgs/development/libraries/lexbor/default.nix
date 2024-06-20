{ stdenv
, fetchFromGitHub
, lib
, cmake }:

stdenv.mkDerivation rec {
  pname = "lexbor";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    rev = "v${version}";
    sha256 = "BgTl932gEbE6qCzKQHNaTPwj70gD/DFh4sbQWAkm8fk=";
  };

  nativeBuildInputs = [ cmake ];

  buildPhase = ''
    cmake . -DLEXBOR_BUILD_TESTS=ON -DLEXBOR_BUILD_EXAMPLES=ON
    make
  '';

  doCheck = true;
  checkPhase = ''
    make test
  '';

  meta = with lib; {
    description = "Lexbor is development of an open source HTML Renderer library.";
    homepage = "https://lexbor.com/";
    license = licenses.apsl20;
    maintainers = with maintainers; [ gp2112 ];
    platforms = platforms.x86_64;
  };

}
