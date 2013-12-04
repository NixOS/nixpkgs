{ stdenv, fetchurl, libxml2 }:

stdenv.mkDerivation rec {
  name = "libxslt-1.1.28";

  src = fetchurl {
    url = "ftp://xmlsoft.org/libxml2/${name}.tar.gz";
    sha256 = "5fc7151a57b89c03d7b825df5a0fae0a8d5f05674c0e7cf2937ecec4d54a028c";
  };

  buildInputs = [ libxml2 ];

  patches = stdenv.lib.optionals stdenv.isSunOS [ ./patch-ah.patch ];

  configureFlags = [
    "--with-libxml-prefix=${libxml2}"
    "--without-python"
    "--without-crypto"
    "--without-debug"
    "--without-mem-debug"
    "--without-debugger"
  ];

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
}
