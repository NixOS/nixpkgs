{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "unicorn";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = pname;
    rev = version;
    hash = "sha256-D8kwrHo58zksVjB13VtzoVqmz++FRfJ4zI2CT+YeBVE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    IOKit
  ];

  meta = with lib; {
    description = "Lightweight multi-platform CPU emulator library";
    homepage = "https://www.unicorn-engine.org";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice luc65r ];
  };
}
