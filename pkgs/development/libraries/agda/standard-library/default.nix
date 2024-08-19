{ lib, mkDerivation, fetchFromGitHub, ghcWithPackages, nixosTests, fetchpatch }:

mkDerivation rec {
  pname = "standard-library";
  version = "2.1";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    hash = "sha256-tv/Fj8ZJgSvieNLlXBjyIR7MSmDp0e2QbN1d/0xBpFg=";
  };

  # for compatibility with Agda 2.7.0 (these commits are from the experimental
  # branch of the upstream repository)
  patches = [
    (fetchpatch {
      url = "https://github.com/agda/agda-stdlib/commit/c7d65e0c40fb257979316c321a4ae0730c1764c1.diff";
      sha256 = "sha256-9+6V2rD+kGrgbf3sN0HCt6uwoitgALfIiFKFFTcBKQc=";
    })
    (fetchpatch {
      url = "https://github.com/agda/agda-stdlib/commit/586f56ade1574c83e11f63c4a5139fd24becc95c.diff";
      sha256 = "sha256-9xBn13zbsKmyjisrTUJXbI8c3zKJCFbM8aYbqtxfUnQ=";
    })
  ];

  nativeBuildInputs = [ (ghcWithPackages (self : [ self.filemanip ])) ];
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
    maintainers = with maintainers; [ jwiegley mudri alexarice turion ];
  };
}
