{
  lib,
  stdenv,
  fetchurl,
  pciutils,
  libx86,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "vbetool";
  version = "1.1";

  src = fetchurl {
    url = "https://www.codon.org.uk/~mjg59/vbetool/download/${pname}-${version}.tar.gz";
    sha256 = "0m7rc9v8nz6w9x4x96maza139kin6lg4hscy6i13fna4672ds9jd";
  };

  buildInputs = [
    pciutils
    libx86
    zlib
  ];

  patchPhase = ''
    substituteInPlace Makefile.in --replace '$(libdir)/libpci.a' ""
  '';

  configureFlags = [ "LDFLAGS=-lpci" ];

  meta = with lib; {
    description = "Video BIOS execution tool";
    homepage = "https://www.codon.org.uk/~mjg59/vbetool/";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    mainProgram = "vbetool";
  };
}
