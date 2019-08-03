{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

with lib;

stdenv.mkDerivation rec {
  name = "libytnef-${version}";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "Yeraze";
    repo = "ytnef";
    rev = "v${version}";
    sha256 = "07h48s5qf08503pp9kafqbwipdqghiif22ghki7z8j67gyp04l6l";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    inherit (src.meta) homepage;
    description = "Yeraze's TNEF Stream Reader - for winmail.dat files";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
