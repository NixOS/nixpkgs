{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  autoreconfHook,
  automake,
  libtool,
}:
stdenv.mkDerivation rec {
  pname = "ta-lib";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "TA-lib";
    repo = "ta-lib";
    rev = "v${version}";
    sha256 = "sha256-aTRiScPNWsGDwJvumZXlMilvSDYZVDWgpeZ2F/S5WgQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    autoconf
    automake
    libtool
  ];

  configureFlags = [
    "--libdir=${placeholder "out"}/lib"
  ];

  meta = with lib; {
    description = "A widely used library for technical analysis of financial market data";
    homepage = "https://ta-lib.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      rafael
      lpbigfish
    ];
  };
}
