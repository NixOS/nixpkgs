{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "systemc";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "accellera-official";
    repo = "systemc";
    rev = version;
    sha256 = "sha256-v/PcQu0m/7zyx2TtpZrLFbHtknahgVCkzcRi3lgrRGw=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # Undefined reference to the sc_core::sc_api_version_2_3_4_XXX
    # https://github.com/accellera-official/systemc/issues/21
    "-DCMAKE_CXX_STANDARD=17"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    description = "Language for System-level design, modeling and verification";
    homepage = "https://systemc.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ amiloradovsky ];
  };
}
