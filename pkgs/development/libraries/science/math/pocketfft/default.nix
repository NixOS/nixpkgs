{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  strictDeps = true;
  pname = "pocketfft";
  version = finalAttrs.src.rev;
  src = fetchFromGitHub {
    owner = "mreineck";
    repo = finalAttrs.pname;
    rev = "076cb3d2536b7c5d0629093ad886e10ac05f3623";
    hash = "sha256-9j26WipCJyWj2Z5YTEB3xTbwLlN4FnBzZUcM/WIppYk=";
  };
  dontConfigure = true;
  dontBuild = true;
  doCheck = true;
  preCheck = ''
    c++ -std=c++11 -O2 -o pocketfft_demo pocketfft_demo.cc
    echo "Running pocketfft_demo"
    ./pocketfft_demo > /dev/null
    echo "Success!"
  '';
  preInstall = ''
    mkdir -p "$out/include"
    cp "$src/pocketfft_hdronly.h" "$out/include/pocketfft_hdronly.h"
  '';
  meta = with lib; {
    description = "Heavily modified implementation of FFTPack";
    homepage = "https://github.com/mreineck/pocketfft";
    license = licenses.bsd3;
    maintainers = with maintainers; [connorbaker];
    platforms = platforms.all;
  };
})
