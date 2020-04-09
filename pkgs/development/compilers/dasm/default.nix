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
		patchShebangs ./tests/
	'';

	checkTarget = "tests";

	meta = with stdenv.lib; {
		homepage = "https://dasm-assembler.github.io";
		description = "Assembler for 6502 and other 8-bit microprocessors";
		license = licenses.gpl2;
		maintainers = [ maintainers.jwatt ];
		platforms = platforms.all;
	};
}
