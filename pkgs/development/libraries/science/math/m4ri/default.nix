{ stdenv
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
    sha256 = "1dxgbv6zdyki3h61qlv7003wzhy6x14zmcaz9x19md1i7ng07w1k";
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
