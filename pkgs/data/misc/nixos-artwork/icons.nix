{ stdenv
, lib
, fetchFromGitHub
, imagemagick
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nixos-icons";
  version = "0-unstable-2024-04-10";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixos-artwork";
    rev = "f84c13adae08e860a7c3f76ab3a9bef916d276cc";
    hash = "sha256-lO/2dLGK2f9pzLHudRIs4PUcGUliy7kfyt9r4CbhbVg=";
  };

  sourceRoot = "${finalAttrs.src.name}/icons";

  strictDeps = true;

  nativeBuildInputs = [
    imagemagick
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Icons of the Nix logo, in Freedesktop Icon Directory Layout";
    homepage = "https://github.com/NixOS/nixos-artwork";
    license = licenses.cc-by-40;
    maintainers = [ ];
    platforms = platforms.all;
  };
})
