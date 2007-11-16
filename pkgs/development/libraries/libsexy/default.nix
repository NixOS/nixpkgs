{ stdenv, fetchurl, pkgconfig, libxml2, glib, gtk, pango
}:
 
stdenv.mkDerivation {
  name = "libsexy-0.1.11";
  #builder = ./builder.sh;

  src = fetchurl {
    url = http://releases.chipx86.com/libsexy/libsexy/libsexy-0.1.11.tar.gz;
    sha256 = "8c4101a8cda5fccbba85ba1a15f46f2cf75deaa8b3c525ce5b135b9e1a8fe49e";
  };

  buildInputs = [ pkgconfig libxml2 glib gtk pango
  ];

  #configureFlags="";  
}
