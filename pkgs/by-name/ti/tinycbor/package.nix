{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "tinycbor";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tinycbor";
    rev = "v${version}";
    hash = "sha256-JgkZAvZ63jjTdFRnyk+AeIWcGsg36UtPPFbhFjky9e8=";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Concise Binary Object Representation (CBOR) Library";
    mainProgram = "cbordump";
    homepage = "https://github.com/intel/tinycbor";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
