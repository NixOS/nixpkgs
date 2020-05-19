{ lib, mkDerivation, fetchFromGitHub, ghc, glibcLocales }:

mkDerivation rec {

  # Version 0.2 is meant to be used with the Agda 2.6.1 compiler.
  pname = "cubical";
  version = "0.2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "agda";
    rev = "v${version}";
    sha256 = "07qlp2f189jvzbn3aqvpqk2zxpkmkxhhkjsn62iq436kxqj3z6c2";
  };

  LC_ALL = "en_US.UTF-8";

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
