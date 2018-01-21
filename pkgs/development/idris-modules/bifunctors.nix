{ build-idris-package, fetchFromGitHub, lib, idris, base, prelude }:

# There's another partially maintained package at
# https://github.com/HuwCampbell/Idris-Bifunctors
build-idris-package {
  name = "bifunctors-2016-08-10";

  src = fetchFromGitHub {
    owner = "japesinator";
    repo = "Idris-Bifunctors";
    rev = "18d579341956abf240ab1470306a817e4aaf5e56";
    sha256 = "12jrwifdc6yznf4g2qz7c8bjcp93bf8x25yadvp6ccx1vyid1a67";
  };

  propagatedBuildInputs = [ prelude base ];

  buildPhase = ''
      ${idris}/bin/idris --build bifunctors.ipkg
  '';

  checkPhase = ''
      export PATH=$PATH:${idris}/bin
      sh test.sh
  '';

  installPhase = ''
      ${idris}/bin/idris --install bifunctors.ipkg
  '';

  meta = {
    description = "A small bifunctor library for idris";
    longDescription = ''
      This is a bifunctor library for idris based off the excellent Haskell
      Bifunctors package from Edward Kmett.
    '';
    homepage = https://github.com/japesinator/Idris-Bifunctors;
    license = lib.licenses.bsd3;
    inherit (idris.meta) platforms;
  };
}
