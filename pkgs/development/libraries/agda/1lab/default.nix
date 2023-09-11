{ lib, mkDerivation, fetchFromGitHub }:

mkDerivation rec {
  pname = "1lab";
  version = "unstable-2023-03-07";

  src = fetchFromGitHub {
    owner = "plt-amy";
    repo = pname;
    # Last commit that compiles with Agda 2.6.3
    rev = "c6ee57a2da327def241324b4775ec2c67cdab2af";
    hash = "sha256-zDqFaDZxAdFxYM6l2zc7ZTi4XwMThw1AQwHfvhOxzdg=";
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
