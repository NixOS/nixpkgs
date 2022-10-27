{ lib, mkDerivation, fetchFromGitHub, ghc, glibcLocales }:

mkDerivation rec {
  pname = "cubical";
  version = "0.4prec3e097a";

  src = fetchFromGitHub {
    repo = pname;
    owner = "agda";
    rev = "c3e097a98c84083550fa31101346bd42a0501add";
    sha256 = "101cni2a9xvia1mglb94z61jm8xk9r5kc1sn44cri0qsmk1zbqxs";
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
