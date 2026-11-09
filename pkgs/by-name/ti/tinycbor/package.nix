{
  cmake,
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinycbor";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "tinycbor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M4L6RO0G6QIRt7ALU8kV1FolGSdvWJnny7J2FJgrE5g=";
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
