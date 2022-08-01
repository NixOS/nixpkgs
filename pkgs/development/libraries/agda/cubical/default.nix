{ lib, mkDerivation, fetchFromGitHub, ghc, glibcLocales }:

mkDerivation rec {
  pname = "cubical";
  version = "0.4pre35719e3";

  src = fetchFromGitHub {
    repo = pname;
    owner = "agda";
    rev = "35719e3d90b1e71e45478c133e591936453e93fc";
    sha256 = "sha256-7H/CSSfFEDsonlPUy5fXUfWAb0vqrlclDkbEkFwwV7Q=";
  };

  LC_ALL = "en_US.UTF-8";

  preConfigure = ''export AGDA_EXEC=agda'';

  # The cubical library has several `Everything.agda` files, which are
  # compiled through the make file they provide.
  nativeBuildInputs = [ ghc glibcLocales ];
  buildPhase = ''
    make
  '';

  meta = with lib; {
    description =
      "A cubical type theory library for use with the Agda compiler";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ alexarice ryanorendorff ];
  };
}
