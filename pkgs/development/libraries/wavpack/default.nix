{ lib, stdenv, fetchFromGitHub, autoreconfHook, libiconv }:

stdenv.mkDerivation rec {
  pname = "wavpack";
  version = "5.4.0";

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optional stdenv.isDarwin libiconv;

  src = fetchFromGitHub {
    owner = "dbry";
    repo = "WavPack";
    rev = version;
    sha256 = "1b6szk2vmnqnv5w7h8yc1iazjlidlraq1lwjbmc3fi0snbn6qj44";
  };

  meta = with lib; {
    description = "Hybrid audio compression format";
    homepage    = "https://www.wavpack.com/";
    changelog   = "https://github.com/dbry/WavPack/releases/tag/${version}";
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
