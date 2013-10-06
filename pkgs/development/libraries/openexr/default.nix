{ stdenv, fetchurl, pkgconfig, zlib, ctl, ilmbase }:

stdenv.mkDerivation rec {
  name = "openexr-1.7.1";
  
  src = fetchurl {
    url = "mirror://savannah/openexr/${name}.tar.gz";
    sha256 = "0l2rdbx9lg4qk2ms98hwbsnzpggdrx3pbjl6pcvrrpjqp5m905n6";
  };
  
  buildInputs = [ pkgconfig ctl ];
  
  propagatedBuildInputs = [ zlib ilmbase ];
  
  configureFlags = "--enable-imfexamples";
  
  patches = [ ./stringh.patch ];
}
