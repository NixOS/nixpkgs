{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  mesonEmulatorHook,
}:

stdenv.mkDerivation rec {
  pname = "test-drive";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "fortran-lang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ObAnHFP1Hp0knf/jtGHynVF0CCqK47eqetePx4NLmlM=";
  };

  nativeBuildInputs =
    [
      gfortran
      meson
      ninja
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      mesonEmulatorHook
    ];

  meta = with lib; {
    description = "Procedural Fortran testing framework";
    homepage = "https://github.com/fortran-lang/test-drive";
    license = with licenses; [
      asl20
      mit
    ];
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
