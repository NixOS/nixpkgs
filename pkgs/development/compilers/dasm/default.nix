{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dasm";
  version = "2.20.13";

  src = fetchFromGitHub {
    owner = "dasm-assembler";
    repo = "dasm";
    rev = version;
    sha256 = "1nr4kvw42vyc6i4p1c06jlih11rhbjjxc27dc7cx5qj635xf4jcf";
  };

  configurePhase = false;
  installPhase = ''
    mkdir -p $out/bin
    install bin/* $out/bin
  '';

  preCheck = ''
    patchShebangs ./test/
  '';

  checkTarget = "test";
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Assembler for 6502 and other 8-bit microprocessors";
    homepage = "https://dasm-assembler.github.io";
    license = licenses.gpl2;
    maintainers = [ maintainers.jwatt ];
    platforms = platforms.all;
  };
}
