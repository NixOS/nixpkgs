{stdenv, fetchurl, libxml2 }:

stdenv.mkDerivation rec {
  name = "libxslt-1.1.26";
  
  src = fetchurl {
    url = "ftp://xmlsoft.org/libxml2/${name}.tar.gz";
    sha256 = "1c9xdv39jvq1hp16gsbi56hbz032dmqyy0fpi4ls1y3152s55pam";
  };
  
  buildInputs = [libxml2];
  
  postInstall = ''
    ensureDir $out/nix-support
    ln -s ${libxml2}/nix-support/setup-hook $out/nix-support/
  '';

  meta = {
    homepage = http://xmlsoft.org/XSLT/;
    description = "A C library and tools to do XSL transformations";
    license = "bsd";
  };
}
