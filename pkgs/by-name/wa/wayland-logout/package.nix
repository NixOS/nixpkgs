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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VSAw6go4v937HWazXfMz8OdHgOnUtrlDXkslsV4eDIg=";
  };
  nativeBuildInputs = [
    meson
    ninja
  ];
  meta = with lib; {
    description = ''
      A utility designed to kill a single instance of a wayland compositor
    '';
    mainProgram = "wayland-logout";
    homepage = "https://github.com/soreau/wayland-logout";
    maintainers = with maintainers; [ quantenzitrone ];
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
}
