{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "sokol";
<<<<<<< HEAD
  version = "unstable-2023-08-04";
=======
  version = "unstable-2022-06-13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "floooh";
    repo = "sokol";
<<<<<<< HEAD
    rev = "47d92ff86298fc96b3b84d93d0ee8c8533d3a2d2";
    sha256 = "sha256-TsM5wK9a2ectrAY8VnrMPaxCNV3e1yW92SBBCHgs+0k=";
=======
    rev = "3c7016105f3b7463f0cfc74df8a55642e5448c11";
    sha256 = "sha256-dKHb6GTp5aJPuWWXI4ZYnhgdXs23gGWyPymGPGwxcLY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/sokol
    cp *.h $out/include/sokol/
    cp -R util $out/include/sokol/util

    runHook postInstall
  '';

  meta = with lib; {
    description = "Minimal cross-platform standalone C headers";
    homepage = "https://github.com/floooh/sokol";
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = with maintainers; [ jonnybolton ];
  };
}

