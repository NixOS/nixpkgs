{ lib, mkDerivation, fetchFromGitHub, ghcWithPackages, nixosTests }:

mkDerivation rec {
  pname = "standard-library";
  version = "1.7";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    sha256 = "14h3jprm6924g9576v25axn9v6xnip354hvpzlcqsc5qqyj7zzjs";
  };

  nativeBuildInputs = [ (ghcWithPackages (self : [ self.filemanip ])) ];
  preConfigure = ''
    runhaskell GenerateEverything.hs
    # We will only build/consider Everything.agda, in particular we don't want Everything*.agda
    # do be copied to the store.
    rm EverythingSafe.agda
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
