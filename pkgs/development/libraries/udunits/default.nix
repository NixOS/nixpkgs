{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, bison
, expat
, file
, flex
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "udunits";
  version = "unstable-2021-03-17";

  src = fetchFromGitHub {
    owner = "Unidata";
    repo = "UDUNITS-2";
    rev = "c83da987387db1174cd2266b73dd5dd556f4476b";
    hash = "sha256-+HW21+r65OroCxMK2/B5fe7zHs4hD4xyoJK2bhdJGyQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    texinfo
    bison
    flex
    file
  ];
  buildInputs = [
    expat
  ];

  meta = with lib; {
    homepage = "https://www.unidata.ucar.edu/software/udunits/";
    description = "A C-based package for the programatic handling of units of physical quantities";
    longDescription = ''
      The UDUNITS package supports units of physical quantities. Its C library
      provides for arithmetic manipulation of units and for conversion of
      numeric values between compatible units. The package contains an extensive
      unit database, which is in XML format and user-extendable. The package
      also contains a command-line utility for investigating units and
      converting values.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ AndersonTorres pSub ];
    platforms = platforms.all;
    mainProgram = "udunits2";
  };
}
