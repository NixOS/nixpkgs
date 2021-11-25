{ lib, mkDerivation, fetchFromGitHub, ghc, glibcLocales }:

mkDerivation rec {
  pname = "cubical";
  version = "0.3pred5030a9";

  src = fetchFromGitHub {
    repo = pname;
    owner = "agda";
    rev = "d5030a9c89070255fc575add4e9f37b97e6a0c0c";
    sha256 = "18achbxap4ikydigmz3m3xjfn3i9dw4rn8yih82vrlc01j02nqpi";
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
