{ lib, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "unicorn";
  version = "2.0.0-rc6";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = pname;
    rev = version;
    sha256 = "1gqlc2y6qgiby9z3f1yv3ngz8rv8zn2fxfjrl124n72gm50b37yw";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with lib; {
    description = "Lightweight multi-platform CPU emulator library";
    homepage = "https://www.unicorn-engine.org";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice luc65r ];
  };
}
