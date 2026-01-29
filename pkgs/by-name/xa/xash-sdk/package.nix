{
  lib,
  fetchFromGitHub,
  stdenv,
  wafHook,
  python3Packages,
}:

stdenv.mkDerivation {
  pname = "xash-sdk";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "FWGS";
    repo = "hlsdk-portable";
    fetchSubmodules = true;
    rev = "5fae1fb3cbfa26991bb592d95b5162cb6de29b83";
    hash = "sha256-+ufUD8B7FvJeY4G9BLvLRPAIZg/x/4XtS0SgBKRGLjw=";
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
    description = "Portable crossplatform Half-Life SDK for GoldSource and Xash3D engines";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ r4v3n6101 ];
  };
}
