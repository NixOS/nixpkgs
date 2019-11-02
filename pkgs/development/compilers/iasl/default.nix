{stdenv, fetchurl, fetchpatch, bison, flex}:

stdenv.mkDerivation rec {
  pname = "iasl";
  version = "20191018";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "0pz95fb1zvsj9238bg7a4vxl1svn5mnjg10sn5qvgr008q0v9782";
  };

  NIX_CFLAGS_COMPILE = [
    "-O3"
  ];

  buildFlags = "iasl";

  buildInputs = [ bison flex ];

  installPhase =
    ''
      install -d $out/bin
      install generate/unix/bin*/iasl $out/bin
    '';

  meta = {
    description = "Intel ACPI Compiler";
    homepage = http://www.acpica.org/;
    license = stdenv.lib.licenses.iasl;
    platforms = stdenv.lib.platforms.unix;
  };
}
