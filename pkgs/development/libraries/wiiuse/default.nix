{ lib
, stdenv
, fetchFromGitHub
, cmake
, bluez
, libobjc
, Foundation
, IOBluetooth
}:
stdenv.mkDerivation rec {

  pname = "WiiUse";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "wiiuse";
    repo = "wiiuse";
    rev = version;
    sha256 = "05gc3s0wxx7ga4g32yyibyxdh46rm9bbslblrc72ynrjxq98sg13";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ bluez ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libobjc Foundation IOBluetooth ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ bluez ];

  cmakeFlags = [ "-DBUILD_EXAMPLE_SDL=OFF" ];

  meta = with lib; {
    description = "Feature complete cross-platform Wii Remote access library";
    mainProgram = "wiiuseexample";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/wiiuse/wiiuse";
    maintainers = with maintainers; [ shamilton ];
    platforms = with platforms; unix;
  };
}
