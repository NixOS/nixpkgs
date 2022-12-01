{ lib, mkDerivation, fetchFromGitHub, ghc, glibcLocales }:

mkDerivation rec {
  pname = "cubical";
  version = "0.4";

  src = fetchFromGitHub {
    repo = pname;
    owner = "agda";
    rev = "v${version}";
    hash = "sha256-bnHz5uZXZnn1Zd36tq/veA4yT7dhJ1c+AYpgdDfSRzE=";
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
