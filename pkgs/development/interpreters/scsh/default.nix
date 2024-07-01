{ lib, stdenv, fetchFromGitHub, autoreconfHook, scheme48, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "scsh";
  version = "0.7-unstable-2024-03-09";

  src = fetchFromGitHub {
    owner = "scheme";
    repo = "scsh";
    rev = "6770db21b08edd907d1c9bd962297ff55664e3fe";
    hash = "sha256-U95Rc/Ks5AytB5UwbzQLI3/Sj4TYybrp8/45fu9krSU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ scheme48 ];
  configureFlags = [ "--with-scheme48=${scheme48}" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Scheme shell";
    homepage = "http://www.scsh.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
    platforms = with platforms; unix;
    mainProgram = "scsh";
  };
}
