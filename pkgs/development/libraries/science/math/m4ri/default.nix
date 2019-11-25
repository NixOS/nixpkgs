{ stdenv
, fetchFromBitbucket
, autoreconfHook
}:

stdenv.mkDerivation rec {
  version = "20140914";
  pname = "m4ri";

  src = fetchFromBitbucket {
    owner = "malb";
    repo = "m4ri";
    rev = "release-${version}";
    sha256 = "0xfg6pffbn8r1s0y7bn9b8i55l00d41dkmhrpf7pwk53qa3achd3";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with stdenv.lib; {
    homepage = https://malb.bitbucket.io/m4ri/;
    description = "Library to do fast arithmetic with dense matrices over F_2";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.unix;
  };
}
