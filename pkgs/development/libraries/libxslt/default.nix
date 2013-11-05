{ stdenv, fetchurl, libxml2 }:

stdenv.mkDerivation (rec {
  name = "libxslt-1.1.27";

  src = fetchurl {
    url = "ftp://xmlsoft.org/libxml2/${name}.tar.gz";
    sha256 = "09ky3vhlaahvsb0q9gp6h3as53pfj70gincirachjqzj46jdka5n";
  };

  buildInputs = [ libxml2 ];

  postInstall = ''
    mkdir -p $out/nix-support
    ln -s ${libxml2}/nix-support/setup-hook $out/nix-support/
  '';

  meta = {
    homepage = http://xmlsoft.org/XSLT/;
    description = "A C library and tools to do XSL transformations";
    license = "bsd";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
} // (if !stdenv.isFreeBSD then {} else {
  buildInputs = [];

  configureFlags = [
    "--with-libxml-prefix=${libxml2}"
    "--without-python"
    "--without-crypto"
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ];
}))
