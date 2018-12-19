{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "iasl-${version}";
  version = "20181213";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "1vgqlv9pvxc52faxixpgz7hi1awqmj88bw5vqn3bldf6fmkh147w";
  };

  NIX_CFLAGS_COMPILE = "-O3";

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
    platforms = stdenv.lib.platforms.linux;
  };
}
