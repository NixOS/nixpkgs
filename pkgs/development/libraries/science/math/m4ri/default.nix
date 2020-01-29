{ stdenv
, fetchFromBitbucket
, autoreconfHook
}:

stdenv.mkDerivation rec {
  version = "20200115";
  pname = "m4ri";

  src = fetchFromBitbucket {
    owner = "malb";
    repo = "m4ri";
    rev = "release-${version}";
    sha256 = "1c17casrw6dvwj067kfcgyjjajfisz56s30wjv7fwaw55mqrny19";
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
