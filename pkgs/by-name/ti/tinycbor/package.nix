{
  cmake,
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinycbor";
  version = "7.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tinycbor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Fuw/hV3tVzoKf2Xrw64xuU+7xzSRPWL/ZdLjF0qICDY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Concise Binary Object Representation (CBOR) Library";
    mainProgram = "cbordump";
    homepage = "https://github.com/intel/tinycbor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbutter ];
  };
})
