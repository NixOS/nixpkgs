{stdenv, fetchurl, fetchpatch, bison, flex}:

stdenv.mkDerivation rec {
  pname = "iasl";
  version = "20181213";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "1vgqlv9pvxc52faxixpgz7hi1awqmj88bw5vqn3bldf6fmkh147w";
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
    platforms = stdenv.lib.platforms.unix;
  };
}
