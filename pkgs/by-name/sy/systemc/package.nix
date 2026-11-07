{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "systemc";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "accellera-official";
    repo = "systemc";
    tag = finalAttrs.version;
    hash = "sha256-v/PcQu0m/7zyx2TtpZrLFbHtknahgVCkzcRi3lgrRGw=";
  };

  # consumers must see the SC_CPLUSPLUS the library was built with, otherwise it follows their own -std and fails to link
  postPatch = ''
    substituteInPlace src/sysc/kernel/sc_cmnhdr.h \
      --replace-fail '#  define SC_CPLUSPLUS SC_CPLUSPLUS_AUTO_' '#  define SC_CPLUSPLUS 201703L'
  '';

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
    maintainers = with lib.maintainers; [ atalii ];
  };
})
