{
  lib,
  mkDerivation,
  fetchFromGitHub,
  standard-library,
}:

mkDerivation rec {
  pname = "standard-library-classes";
  version = "2.4";

  libraryFile = "agda-stdlib-classes.agda-lib";

  src = fetchFromGitHub {
    repo = "agda-stdlib-classes";
    owner = "agda";
    rev = "v${version}";
    hash = "sha256-Wzeg5d527TXFgbInht4GdC2B24GLSEHuEt+23tM6dA8=";
  };

  buildInputs = [ standard-library ];

  meta = {
    homepage = "https://github.com/agda/agda-stdlib-classes";
    description = "Type-classes for the Agda standard library";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      carlostome
    ];
  };
}
