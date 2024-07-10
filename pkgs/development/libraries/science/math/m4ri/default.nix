{ lib, stdenv
, fetchFromBitbucket
, autoreconfHook
}:

stdenv.mkDerivation rec {
  version = "20200125";
  pname = "m4ri";

  src = fetchFromBitbucket {
    owner = "malb";
    repo = "m4ri";
    rev = "release-${version}";
    hash = "sha256-M/ADnj0xtJpCT1+x+knoxsPPBwBnUxwMHHH69s1er7c=";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    homepage = "https://malb.bitbucket.io/m4ri/";
    description = "Library to do fast arithmetic with dense matrices over F_2";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
