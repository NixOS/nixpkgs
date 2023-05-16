{ fetchFromGitHub
<<<<<<< HEAD
=======
, gcc
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, lib
, libnl
, libpcap
, pkg-config
, stdenv
<<<<<<< HEAD
=======
, writeShellScriptBin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:
stdenv.mkDerivation rec {
  pname = "nmrpflash";
  version = "0.9.20";

  src = fetchFromGitHub {
    owner  = "jclehner";
    repo   = "nmrpflash";
    rev    = "v${version}";
    sha256 = "sha256-xfKZXaKzSTnCOC8qt6Zc/eidc1bnrKZOJPw/wwMoCaM=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libnl libpcap ];

  PREFIX = "${placeholder "out"}";
<<<<<<< HEAD
  STANDALONE_VERSION = version;
=======
  STANDALONE_VERSION = "${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Netgear Unbrick Utility";
    homepage = "https://github.com/jclehner/nmrpflash";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dadada ];
    platforms = platforms.unix;
  };
}
