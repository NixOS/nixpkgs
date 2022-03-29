{ lib, stdenv, fetchFromGitHub, autoreconfHook, scheme48 }:

stdenv.mkDerivation {
  pname = "scsh";
  version = "0.7pre";

  src = fetchFromGitHub {
    owner = "scheme";
    repo = "scsh";
    rev = "f99b8c5293628cfeaeb792019072e3a96841104f";
    sha256 = "sha256-vcVtqoUhozdJq1beUN8/rcI2qOJYUN+0CPSiDWGCIjI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ scheme48 ];
  configureFlags = [ "--with-scheme48=${scheme48}" ];

  meta = with lib; {
    description = "A Scheme shell";
    homepage = "http://www.scsh.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
    platforms = with platforms; unix;
  };
}
