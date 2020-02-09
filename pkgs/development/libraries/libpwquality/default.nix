{ stdenv, lib, fetchFromGitHub, autoreconfHook, perl, cracklib, python3 }:

stdenv.mkDerivation rec {
  pname = "libpwquality";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "libpwquality";
    repo = "libpwquality";
    rev = "${pname}-${version}";
    sha256 = "0n4pjhm7wfivk0wizggaxq4y4mcxic876wcarjabkp5z9k14y36h";
  };

  nativeBuildInputs = [ autoreconfHook perl ];
  buildInputs = [ cracklib python3 ];

  meta = with lib; {
    description = "Password quality checking and random password generation library";
    homepage = https://github.com/libpwquality/libpwquality;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
