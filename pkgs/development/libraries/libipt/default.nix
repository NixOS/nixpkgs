{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libipt";
<<<<<<< HEAD
  version = "2.0.6";
=======
  version = "2.0.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libipt";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-RuahOkDLbac9bhXn8QSf7lMRw11PIpXQo3eaQ9N4Rtc=";
=======
    sha256 = "sha256-W7Hvc2zkmR6FdPGsymWXtm66BiHLcW9r7mywHjabeLc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Intel Processor Trace decoder library";
    homepage = "https://github.com/intel/libipt";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
