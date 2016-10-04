{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation {
  name = "iasl-20130117";

  src = fetchurl {
    url = http://www.acpica.org/download/acpica-unix-20130117.tar.gz;
    sha256 = "1zils7l7gnkbbl8916dlhvij1g625ryb7769zhzffn3flshfdivh";
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
