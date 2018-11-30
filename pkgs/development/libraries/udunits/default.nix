{ stdenv, fetchFromGitHub, autoreconfHook,
  texinfo, bison, flex, expat, file
}:

stdenv.mkDerivation rec {
  name = "udunits-${version}";
  version = "2.2.27.6";
  
  src = fetchFromGitHub {
    owner = "Unidata";
    repo = "UDUNITS-2";
    rev = "v${version}";
    sha256 = "0621pac24c842dyipzaa59rh6pza9phdqi3snd4cq4pib0wjw6gm";
  };

  nativeBuildInputs = [ autoreconfHook texinfo bison flex file ];
  buildInputs = [ expat ];

  meta = with stdenv.lib; {
    homepage = https://www.unidata.ucar.edu/software/udunits/;
    description = "A C-based package for the programatic handling of units of physical quantities";
    license = licenses.bsdOriginal;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
