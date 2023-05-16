{ lib, stdenv, fetchFromGitHub, meson, ninja }:
stdenv.mkDerivation rec {
  pname = "directx-headers";
<<<<<<< HEAD
  version = "1.610.2";
=======
  version = "1.610.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectX-Headers";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-se+/TgqKdatTnBlHcBC1K4aOGGfPEW+E1efpP34+xc0=";
=======
    hash = "sha256-lPYXAMFSyU3FopWdE6dDRWD6sVKcjxDVsTbgej/T2sk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ meson ninja ];

  # tests require WSL2
  mesonFlags = [ "-Dbuild-test=false" ];

  meta = with lib; {
    description = "Official D3D12 headers from Microsoft";
    homepage = "https://github.com/microsoft/DirectX-Headers";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
  };
}
