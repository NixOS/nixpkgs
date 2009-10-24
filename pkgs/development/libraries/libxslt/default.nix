{stdenv, fetchurl, libxml2, ...}:

stdenv.mkDerivation {
  name = "libxslt-1.1.24";
  
  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxslt-1.1.24.tar.gz;
    sha256 = "c0c10944841e9a79f29d409c6f8da0d1b1af0403eb3819c82c788dfa6a180b3e";
  };
  
  buildInputs = [libxml2];
  
  postInstall = ''
    ensureDir $out/nix-support
    ln -s ${libxml2}/nix-support/setup-hook $out/nix-support/
  '';

  meta = {
    homepage = http://xmlsoft.org/XSLT/;
    description = "A C library and tools to do XSL transformations";
  };
}
