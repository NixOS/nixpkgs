{ lib, stdenv
, autoreconfHook
, intltool
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
<<<<<<< HEAD
  version = "20230821";
=======
  version = "20230424";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-R+DXpT9Tgt311G/OtmKp3sqN0ex/rlLt3JuSK7kciC0=";
=======
    sha256 = "sha256-qi6dDh6Zk1GpHBpQ+aatAmG9lCdesnJRhK3jVjKYKcQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook intltool ];

  meta = with lib; {
    description = "Monitor database for DDCcontrol";
    homepage = "https://github.com/ddccontrol/ddccontrol-db";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ lib.maintainers.pakhfn ];
  };
}
