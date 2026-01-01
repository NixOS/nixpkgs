{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "wl-clip-persist";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Linus789";
    repo = "wl-clip-persist";
    rev = "v${version}";
    hash = "sha256-MEH8ADsFst/CgTc9QW4x0dBXJ5ssQDVa55qPcsALJRg=";
  };

  cargoHash = "sha256-iQI5Z/gk+EFNQNma+T2/y77F8M+kPuSS2QKO6QV9dm4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ wayland ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = stdenv.hostPlatform.isDarwin;
    description = "Keep Wayland clipboard even after programs close";
    homepage = "https://github.com/Linus789/wl-clip-persist";
    inherit (wayland.meta) platforms;
<<<<<<< HEAD
    license = lib.licenses.mit;
    mainProgram = "wl-clip-persist";
    maintainers = with lib.maintainers; [ name-snrl ];
=======
    license = licenses.mit;
    mainProgram = "wl-clip-persist";
    maintainers = with maintainers; [ name-snrl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
