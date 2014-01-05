{stdenv, fetchurl, cxxSupport ? true, compat185 ? true}:

stdenv.mkDerivation {
  name = "db4-4.8.30";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://download.oracle.com/berkeley-db/db-4.8.30.tar.gz;
    sha256 = "0ampbl2f0hb1nix195kz1syrqqxpmvnvnfvphambj7xjrl3iljg0";
  };
  
  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if compat185 then "--enable-compat185" else "--disable-compat185")
  ];
  
}
