{ lib, stdenv, fetchFromGitHub, autoreconfHook, scheme48 }:

stdenv.mkDerivation {
  pname = "scsh";
  version = "0.7pre";

  src = fetchFromGitHub {
    owner = "scheme";
    repo = "scsh";
    rev = "4acf6e4ed7b65b46186ef0c9c2a1e10bef8dc052";
    sha256 = "sha256-92NtMK5nVd6+WtHj/Rk6iQEkGsNEZySTVZkkbqKrLYY=";
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
