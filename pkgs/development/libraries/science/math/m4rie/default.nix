{ stdenv
, fetchFromBitbucket
, autoreconfHook
, m4ri
}:

stdenv.mkDerivation rec {
  version = "20200115";
  pname = "m4rie";

  src = fetchFromBitbucket {
    owner = "malb";
    repo = "m4rie";
    rev = "release-${version}";
    sha256 = "0s8if80x5d6mikbcfsbbxg347136spahp9f3x8i1hflbwl8xj9k8";
  };

  doCheck = true;

  buildInputs = [
    m4ri
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with stdenv.lib; {
    homepage = https://malb.bitbucket.io/m4rie/;
    description = "Library for matrix multiplication, reduction and inversion over GF(2^k) for 2 <= k <= 10";
    longDescription = ''
      M4RIE is a library for fast arithmetic with dense matrices over small finite fields of even characteristic.
      It uses the M4RI library, implementing the same operations over the finite field F2.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.unix;
  };
}
