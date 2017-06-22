{stdenv, fetchurl, bison, flex}:

stdenv.mkDerivation rec {
  name = "iasl-${version}";
  version = "20170303";

  src = fetchurl {
    url = "https://acpica.org/sites/acpica/files/acpica-unix-${version}.tar.gz";
    sha256 = "1dc933rr11gv1nlaf5j8ih1chdakbjbjkn34jgbm330zppmck4y0";
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
