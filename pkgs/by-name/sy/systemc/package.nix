{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "systemc";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "accellera-official";
    repo = "systemc";
    rev = finalAttrs.version;
    sha256 = "sha256-ReYRKx7H9rxVhvY9gAdxrMu5nlsK2FcVIzfgvZroD/E=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # Undefined reference to the sc_core::sc_api_version_2_3_4_XXX
    # https://github.com/accellera-official/systemc/issues/21
    "-DCMAKE_CXX_STANDARD=17"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    description = "Language for System-level design, modeling and verification";
    homepage = "https://systemc.org/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ amiloradovsky ];
  };
})
