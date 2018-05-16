{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "iasl-${version}";
  version = "20180508";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "1n7lqmv77kg28drahvxzybwl9v4hzwi8i7xkpgliclfcp5ff909b";
  };

  NIX_CFLAGS_COMPILE = [
    "-O3"
    # See: https://github.com/acpica/acpica/issues/387:
    "-Wno-error=format-overflow"
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
    platforms = stdenv.lib.platforms.linux;
  };
}
