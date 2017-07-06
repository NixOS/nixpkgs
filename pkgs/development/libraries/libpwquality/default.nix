{ stdenv, lib, fetchFromGitHub, autoreconfHook, perl, cracklib, python }:

stdenv.mkDerivation rec {
  name = "libpwquality-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "libpwquality";
    repo = "libpwquality";
    rev = name;
    sha256 = "0k564hj2q13z5ag8cj6rnkzm1na7001k4chz4f736p6aqvspv0bd";
  };

  nativeBuildInputs = [ autoreconfHook perl ];
  buildInputs = [ cracklib python ];

  meta = with lib; {
    description = "Password quality checking and random password generation library";
    homepage = "https://github.com/libpwquality/libpwquality";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
