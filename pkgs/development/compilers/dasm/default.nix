{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dasm";
  version = "2.20.14";

  src = fetchFromGitHub {
    owner = "dasm-assembler";
    repo = "dasm";
    rev = version;
    sha256 = "09hzw228j43a78624bmq9cam7y1fjs48d3hpjqh2gn8iwnyk0pnp";
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
