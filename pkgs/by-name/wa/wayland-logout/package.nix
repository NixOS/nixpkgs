{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "wayland-logout";
  version = "1.4";
  src = fetchFromGitHub {
    owner = "soreau";
    repo = "wayland-logout";
    rev = "v${version}";
    hash = "sha256-VSAw6go4v937HWazXfMz8OdHgOnUtrlDXkslsV4eDIg=";
  };
  nativeBuildInputs = [
    meson
    ninja
  ];
<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = ''
      A utility designed to kill a single instance of a wayland compositor
    '';
    mainProgram = "wayland-logout";
    homepage = "https://github.com/soreau/wayland-logout";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ quantenzitrone ];
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.linux;
=======
    maintainers = with maintainers; [ quantenzitrone ];
    license = with licenses; [ mit ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
