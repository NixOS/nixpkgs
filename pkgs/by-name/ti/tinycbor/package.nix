{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinycbor";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tinycbor";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JgkZAvZ63jjTdFRnyk+AeIWcGsg36UtPPFbhFjky9e8=";
  };

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Concise Binary Object Representation (CBOR) Library";
    mainProgram = "cbordump";
    homepage = "https://github.com/intel/tinycbor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
  };
})
