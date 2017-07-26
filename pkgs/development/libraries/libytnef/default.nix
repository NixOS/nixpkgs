{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

with lib;

stdenv.mkDerivation rec {
  name = "libytnef-${version}";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "Yeraze";
    repo = "ytnef";
    rev = "v${version}";
    sha256 = "1aavckl7rjbiakwcf4rrkhchrl450p3vq3dy78cxfmgg0jqnvxqy";
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
