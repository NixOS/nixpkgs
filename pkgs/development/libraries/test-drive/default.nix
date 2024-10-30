{ stdenv, lib, fetchFromGitHub, gfortran, meson, ninja, mesonEmulatorHook }:

stdenv.mkDerivation rec {
  pname = "test-drive";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "fortran-lang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xRx8ErIN9xjxZt/nEsdIQkIGFRltuELdlI8lXA+M030=";
  };

  nativeBuildInputs = [
    gfortran
    meson
    ninja
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  mesonAutoFeatures = "auto";

  meta = with lib; {
    description = "Procedural Fortran testing framework";
    homepage = "https://github.com/fortran-lang/test-drive";
    license = with licenses; [ asl20 mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
