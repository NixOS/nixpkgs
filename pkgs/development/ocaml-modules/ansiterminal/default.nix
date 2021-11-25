{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "ANSITerminal";
  version = "0.8.2";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "Chris00";
    repo = pname;
    rev = version;
    sha256 = "0dyjischrgwlxqz1p5zbqq76jvk6pl1qj75i7ydhijssr9pj278d";
  };

  doCheck = true;

  meta = with lib; {
    description = "A module allowing to use the colors and cursor movements on ANSI terminals";
    longDescription = ''
      ANSITerminal is a module allowing to use the colors and cursor
      movements on ANSI terminals. It also works on the windows shell (but
      this part is currently work in progress).
    '';
    inherit (src.meta) homepage;
    license = licenses.lgpl3;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
