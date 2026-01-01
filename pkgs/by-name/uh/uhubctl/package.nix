{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "uhubctl";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "mvp";
    repo = "uhubctl";
    rev = "v${version}";
    sha256 = "sha256-mpeDePHLsa4sGe2+8X9KQ8AYn7wtybDnaZzxnf4oETQ=";
  };

  nativeBuildInputs = [
    which
    pkg-config
  ];

  buildInputs = [ libusb1 ];

  installFlags = [ "prefix=${placeholder "out"}" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/mvp/uhubctl";
    description = "Utility to control USB power per-port on smart USB hubs";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      prusnak
      carlossless
    ];
    platforms = with lib.platforms; linux ++ darwin;
=======
  meta = with lib; {
    homepage = "https://github.com/mvp/uhubctl";
    description = "Utility to control USB power per-port on smart USB hubs";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      prusnak
      carlossless
    ];
    platforms = with platforms; linux ++ darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "uhubctl";
  };
}
