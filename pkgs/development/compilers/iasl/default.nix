{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation {
  name = "iasl-20090123";
  src = fetchurl {
    url = http://www.acpica.org/download/acpica-unix-20090123.tar.gz;
    md5 = "4ca6484acbf16cf67fd4ba91d32fd0a0";
  };

  buildPhase = "
    cd compiler
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
