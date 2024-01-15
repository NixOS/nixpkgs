{ lib, mkDerivation, fetchFromGitHub }:

mkDerivation rec {
  pname = "1lab";
  version = "unstable-2023-12-04";

  src = fetchFromGitHub {
    owner = "plt-amy";
    repo = pname;
    rev = "47c2a96220b4d14419e5ddb973bc1fa06933e723";
    hash = "sha256-0U6s6sXdynk2IWRBDXBJCf7Gc+gE8AhR1PXZl0DS4yU=";
  };

  # We don't need anything in support; avoid installing LICENSE.agda
  postPatch = ''
    rm -rf support
  '';

  libraryName = "1lab";
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
