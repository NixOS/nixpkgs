{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unshield";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "twogood";
    repo = "unshield";
    rev = finalAttrs.version;
    sha256 = "sha256-CYlrPwNPneJIwvQCnzyfi6MZiXoflMDfUDCRL79+yBk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    openssl
  ];

  meta = {
    description = "Tool and library to extract CAB files from InstallShield installers";
    homepage = "https://github.com/twogood/unshield";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "unshield";
  };
})
