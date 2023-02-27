{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libytnef";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "Yeraze";
    repo = "ytnef";
    rev = "v${version}";
    sha256 = "sha256-P5eTH5pKK+v4LCMAe6JbEbTYOJypmLMYVDYk5tGVZ14=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Yeraze's TNEF Stream Reader - for winmail.dat files";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
