{ lib, stdenv, fetchFromGitHub, autoreconfHook, nasm }:

stdenv.mkDerivation rec {
  pname = "isa-l";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "isa-l";
    rev = "v${version}";
    sha256 = "sha256-AAuSdDQfDW4QFRu0jHwCZ+ZCSjoVqlQiSW1OOFye1Rs=";
  };

  nativeBuildInputs = [ nasm autoreconfHook ];

  preConfigure = ''
    export AS=nasm
  '';

  meta = with lib; {
    description = "A collection of optimised low-level functions targeting storage applications";
    license = licenses.bsd3;
    homepage = "https://github.com/intel/isa-l";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
    broken = stdenv.isDarwin && stdenv.isAarch64; # does not build on M1 mac (asm/hwcap.h file not found) maybe needs gcc not clang?
  };
}
