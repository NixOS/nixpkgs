{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "ANSITerminal";
  version = "0.8.5";

  src = fetchurl {
    url = "https://github.com/Chris00/ANSITerminal/releases/download/${version}/ANSITerminal-${version}.tbz";
    hash = "sha256-q3OyGLajAmfSu8QzEtzzE5gbiwvsVV2SsGuHZkst0w4=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace 'libraries unix bytes' 'libraries unix'
  '';

  doCheck = true;

  meta = with lib; {
    description = "A module allowing to use the colors and cursor movements on ANSI terminals";
    longDescription = ''
      ANSITerminal is a module allowing to use the colors and cursor
      movements on ANSI terminals. It also works on the windows shell (but
      this part is currently work in progress).
    '';
    homepage = "https://github.com/Chris00/ANSITerminal";
    license = licenses.lgpl3;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
