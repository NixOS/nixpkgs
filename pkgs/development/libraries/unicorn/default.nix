{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, IOKit }:

stdenv.mkDerivation rec {
  pname = "unicorn";
  version = "2.0.0-rc4";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = pname;
    rev = version;
    sha256 = "sha256-dNBebXp8HVmmY1RVRYuRFoJ3PStCf4taNTeYKi2lhQM=";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with lib; {
    description = "Lightweight multi-platform CPU emulator library";
    homepage = "http://www.unicorn-engine.org";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice luc65r ];
  };
}
