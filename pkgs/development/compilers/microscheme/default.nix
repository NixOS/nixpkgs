{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  unixtools,
}:

stdenv.mkDerivation rec {
  pname = "microscheme";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "ryansuchocki";
    repo = "microscheme";
    rev = "v${version}";
    sha256 = "5qTWsBCfj5DCZ3f9W1bdo6WAc1DZqVxg8D7pwC95duQ=";
  };

  postPatch = ''
    substituteInPlace makefile --replace gcc ${stdenv.cc.targetPrefix}cc
  '';

  nativeBuildInputs = [
    makeWrapper
    unixtools.xxd
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://ryansuchocki.github.io/microscheme/";
    description = "A Scheme subset for Atmel microcontrollers";
    mainProgram = "microscheme";
    longDescription = ''
      Microscheme is a Scheme subset/variant designed for Atmel
      microcontrollers, especially as found on Arduino boards.
    '';
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ardumont ];
  };
}
