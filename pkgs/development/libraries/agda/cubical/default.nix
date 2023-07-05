{ lib, mkDerivation, fetchFromGitHub, ghc }:

mkDerivation rec {
  pname = "cubical";
  version = "0.5";

  src = fetchFromGitHub {
    repo = pname;
    owner = "agda";
    rev = "v${version}";
    hash = "sha256-47GOfZYwvE9TbGzdy/xSYZagTbjs/oeDpwjYUvI7z3k=";
  };

  # The cubical library has several `Everything.agda` files, which are
  # compiled through the make file they provide.
  nativeBuildInputs = [ ghc ];
  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  meta = with lib; {
    description =
      "A cubical type theory library for use with the Agda compiler";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ alexarice ryanorendorff ncfavier ];
  };
}
