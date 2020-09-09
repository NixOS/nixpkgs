{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, bluez
}:
stdenv.mkDerivation rec {

  pname = "WiiUse";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "wiiuse";
    repo = "wiiuse";
    rev = "${version}";
    sha256 = "05gc3s0wxx7ga4g32yyibyxdh46rm9bbslblrc72ynrjxq98sg13";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ (lib.getDev bluez) ];

  cmakeFlags = [ "-DBUILD_EXAMPLE_SDL=NO" ];

  meta = with lib; {
    description = "Feature complete cross-platform Wii Remote access library";
    license = licenses.gpl3;
    homepage = "https://github.com/wiiuse/wiiuse";
    maintainers = with maintainers; [ shamilton ];
    platforms = with platforms; linux;
  };
}
