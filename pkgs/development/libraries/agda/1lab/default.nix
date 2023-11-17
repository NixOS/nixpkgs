{ lib, mkDerivation, fetchFromGitHub }:

mkDerivation rec {
  pname = "1lab";
  version = "unstable-2023-10-11";

  src = fetchFromGitHub {
    owner = "plt-amy";
    repo = pname;
    rev = "c6e0c3c714486fd6c89ace31443428ba48871685";
    hash = "sha256-PC75NtT0e99HVyFedox+6xz/CY2zP2g4Vzqruj5Bjhc=";
  };

  # We don't need anything in support; avoid installing LICENSE.agda
  postPatch = ''
    rm -rf support
  '';

  libraryName = "cubical-1lab";
  libraryFile = "1lab.agda-lib";
  everythingFile = "src/index.lagda.md";

  meta = with lib; {
    description =
      "A formalised, cross-linked reference resource for mathematics done in Homotopy Type Theory ";
    homepage = src.meta.homepage;
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ncfavier ];
  };
}
