{stdenv, fetchurl, fetchpatch, bison, flex}:

stdenv.mkDerivation rec {
  pname = "iasl";
  version = "20200110";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "1cb6aa6acrixmdzvj9vv4qs9lmlsbkd27pjlz14i1kq1x3xn0gwx";
  };

  NIX_CFLAGS_COMPILE = "-O3";

  buildFlags = [ "iasl" ];

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
