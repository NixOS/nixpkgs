{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  sqlite,
}:

stdenv.mkDerivation {
  pname = "vcprompt";
  version = "1.3.0-unstable-2020-12-28";

  src = fetchFromGitHub {
    owner = "powerman";
    repo = "vcprompt";
    rev = "850bf44cd61723f6b46121f678ff94047e42f802";
    hash = "sha256-w2gpekNx3RA7uxNLg0Nkf9/aoxZj3DR4foKI+4q8SKk=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    sqlite
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Program that prints barebones information about the current working directory for various version control systems";
    homepage = "https://github.com/powerman/vcprompt";
    maintainers = [ ];
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.gpl2Plus;
    mainProgram = "vcprompt";
  };
}
