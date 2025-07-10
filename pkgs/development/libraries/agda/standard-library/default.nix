{
  lib,
  mkDerivation,
  fetchFromGitHub,
  ghcWithPackages,
  nixosTests,
}:

mkDerivation rec {
  pname = "standard-library";
  version = "2.2-unstable-2025-07-03";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "6f8af9452e7fac27bc3b3ad068793b538f07668e";
    hash = "sha256-LD6KasmQ9ZHRNQJ0N4wjyc6JiSkZpmyqQq9B0Wta1n0=";
  };

  nativeBuildInputs = [ (ghcWithPackages (self: [ self.filemanip ])) ];
  preConfigure = ''
    runhaskell GenerateEverything.hs --include-deprecated
    # We will only build/consider Everything.agda, in particular we don't want Everything*.agda
    # do be copied to the store.
    rm EverythingSafe.agda
  '';

  passthru.tests = { inherit (nixosTests) agda; };
  meta = with lib; {
    homepage = "https://wiki.portal.chalmers.se/agda/pmwiki.php?n=Libraries.StandardLibrary";
    description = "Standard library for use with the Agda compiler";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [
      jwiegley
      mudri
      alexarice
      turion
    ];
  };
}
