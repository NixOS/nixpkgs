{ lib, stdenv
, fetchFromGitHub
, pkg-config
, cmake
}:

stdenv.mkDerivation rec {
  pname = "unicorn";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = pname;
    rev = version;
    sha256 = "079azb1df4nwsnsck36b200rnf03aqilw30h3fiaqi1ixash957k";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  meta = with lib; {
    description = "Lightweight multi-platform CPU emulator library";
    homepage = "http://www.unicorn-engine.org";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice luc65r ];
  };
}
