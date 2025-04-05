{
  lib,
  fetchFromGitHub,
  stdenv,
  wafHook,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "xash-sdk";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "FWGS";
    repo = "hlsdk-portable";
    fetchSubmodules = true;
    rev = "ce80d1ff572a529b54d9e857e3d30a22e2a6b36d";
    hash = "sha256-d0snwhJllbICiTVz7ZD+3tLWsgA/XzMe55AMbnG7KMc=";
  };

  nativeBuildInputs = [
    python3Packages.python
    wafHook
  ];

  dontAddPrefix = true;

  wafConfigureFlags = [ "-T release" ] ++ lib.optionals stdenv.buildPlatform.is64bit [ "-8" ];

  wafInstallFlags = [ "--destdir=${placeholder "out"}" ];

  meta = {
    homepage = "https://github.com/FWGS/hlsdk-portable";
    description = "Portable crossplatform Half-Life SDK for GoldSource and Xash3D engines.";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ r4v3n6101 ];
  };
}
