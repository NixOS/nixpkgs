{ stdenvNoCC, lib, fetchurl }:

stdenvNoCC.mkDerivation rec {
  name = "fasm-bin-${version}";

  version = "1.73.15";

  src = fetchurl {
    url = "https://flatassembler.net/fasm-${version}.tgz";
    sha256 = "0yc30y4hkr226629347gcrzi153f10hcp5q7bm3q6ir3gx35xa39";
  };

  installPhase = ''
    install -D fasm${lib.optionalString stdenvNoCC.isx86_64 ".x64"} $out/bin/fasm
  '';

  meta = with lib; {
    description = "x86(-64) macro assembler to binary, MZ, PE, COFF, and ELF";
    homepage = https://flatassembler.net/download.php;
    license = licenses.bsd2;
    maintainers = with maintainers; [ orivej ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
