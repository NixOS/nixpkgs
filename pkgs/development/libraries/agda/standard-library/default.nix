{ lib, mkDerivation, fetchFromGitHub, ghcWithPackages, nixosTests }:

mkDerivation rec {
  pname = "standard-library";
  version = "1.6";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    sha256 = "1smvnid7r1mc4lp34pfrbzgzrcl0gmw0dlkga8z0r3g2zhj98lz1";
  };

  nativeBuildInputs = [ (ghcWithPackages (self : [ self.filemanip ])) ];
  preConfigure = ''
    runhaskell GenerateEverything.hs
    # We will only build/consider Everything.agda, in particular we don't want Everything*.agda
    # do be copied to the store.
    rm EverythingSafe.agda EverythingSafeGuardedness.agda EverythingSafeSizedTypes.agda
  '';

  passthru.tests = { inherit (nixosTests) agda; };
  meta = with lib; {
    homepage = "https://wiki.portal.chalmers.se/agda/pmwiki.php?n=Libraries.StandardLibrary";
    description = "A standard library for use with the Agda compiler";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ jwiegley mudri alexarice turion ];
  };
}
