{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation {
  name = "iasl-20120215";
  src = fetchurl {
    url = http://www.acpica.org/download/acpica-unix-20120215.tar.gz;
    sha256 = "13avirbqdnp7whl6ji8ixkhzdwf1cadl5fg8ggzbxp99bx0rgd5j";
  };

  buildPhase = "
    cd source/compiler
    make
    cd ..
  ";

  installPhase = "
    install -d $out/bin
    install compiler/iasl $out/bin
  ";

  buildInputs = [ bison flex ];

  meta = {
    description = "Intel ACPI Compiler";
    homepage = http://www.acpica.org/;
  };
}
