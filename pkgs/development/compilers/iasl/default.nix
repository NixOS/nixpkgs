{stdenv, fetchurl, fetchpatch, bison, flex}:

stdenv.mkDerivation rec {
  name = "iasl-${version}";
  version = "20180313";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "05ab2xfv9wqwbzjaa9xqgrvvan87rxv29hw48h1gcckpc5smp2wm";
  };

  NIX_CFLAGS_COMPILE = [
    "-O3"
  ];

  buildFlags = "iasl";

  buildInputs = [ bison flex ];

  patches = fetchpatch {
    /* https://github.com/acpica/acpica/pull/389 */
    url = "https://github.com/acpica/acpica/commit/935ca65f7806a3ef9bd02a947e50f3a1f586ac67.patch";
    sha256 = "0jz4bakifphm425shbd1j99hldgy71m7scl8mwibm441d56l3ydf";
  };

  installPhase =
    ''
      install -d $out/bin
      install generate/unix/bin*/iasl $out/bin
    '';

  meta = {
    description = "Intel ACPI Compiler";
    homepage = http://www.acpica.org/;
    license = stdenv.lib.licenses.iasl;
    platforms = stdenv.lib.platforms.linux;
  };
}
