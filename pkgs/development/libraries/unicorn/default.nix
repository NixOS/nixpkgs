{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "unicorn";
  version = "2.0.0-rc7";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = pname;
    rev = version;
    hash = "sha256-qlxtFCJBmouPuUEu8RduZM+rbOr52sGjdb8ZRHWmJ/w=";
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
