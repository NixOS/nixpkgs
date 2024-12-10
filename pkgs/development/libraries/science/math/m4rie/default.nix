{
  lib,
  stdenv,
  fetchFromBitbucket,
  autoreconfHook,
  m4ri,
}:

stdenv.mkDerivation rec {
  version = "20200125";
  pname = "m4rie";

  src = fetchFromBitbucket {
    owner = "malb";
    repo = "m4rie";
    rev = "release-${version}";
    sha256 = "sha256-bjAcxfXsC6+jPYC472CN78jm4UljJQlkWyvsqckCDh0=";
  };

  doCheck = true;

  buildInputs = [
    m4ri
  ];

  # does not compile correctly with -O2 on LLVM clang; see
  # https://bitbucket.org/malb/m4rie/issues/23/trying-to-compile-on-apple-m1
  makeFlags = [ ] ++ lib.optionals stdenv.isDarwin [ "CFLAGS=-O0" ];
  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    homepage = "https://malb.bitbucket.io/m4rie/";
    description = "Library for matrix multiplication, reduction and inversion over GF(2^k) for 2 <= k <= 10";
    longDescription = ''
      M4RIE is a library for fast arithmetic with dense matrices over small finite fields of even characteristic.
      It uses the M4RI library, implementing the same operations over the finite field F2.
    '';
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
