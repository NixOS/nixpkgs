{ stdenv, lib, fetchFromGitHub, autoreconfHook, perl, cracklib, python }:

stdenv.mkDerivation rec {
  pname = "libpwquality";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "libpwquality";
    repo = "libpwquality";
    rev = "${pname}-${version}";
    sha256 = "150gk1d0gq9cig3ylyns7fgihgm3qb1basncahgyh1kzxplrdqm7";
  };

  nativeBuildInputs = [ autoreconfHook perl ];
  buildInputs = [ cracklib python ];

  meta = with lib; {
    description = "Password quality checking and random password generation library";
    homepage = https://github.com/libpwquality/libpwquality;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
