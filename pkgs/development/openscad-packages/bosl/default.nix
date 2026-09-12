{
  lib,
  buildOpenSCADPackage,
  fetchFromGitHub,
}:

buildOpenSCADPackage (finalAttrs: {
  pname = "bosl";
  version = "unstable-2023-02-19";
  libName = "BOSL";

  installTargets = [ "*.scad" ];

  src = fetchFromGitHub {
    owner = "revarbat";
    repo = "BOSL";
    rev = "4ce427a8a38786e5f74b728c1e33d9fe7d4904d2";
    hash = "sha256-24vqGt0TPe09K1WTP8fDX2Wx4MlsDnigzx7Ha0mXCOg=";
  };

  meta = {
    description = "The Belfry OpenScad Library - A library of tools, shapes, and helpers to make OpenScad easier to use.";
    homepage = "https://github.com/revarbat/BOSL";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ xoconoch ];
  };
})
