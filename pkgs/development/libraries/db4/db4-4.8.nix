{stdenv, fetchurl, cxxSupport ? true, compat185 ? true}:

stdenv.mkDerivation {
  name = "db4-4.8.26";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://download.oracle.com/berkeley-db/db-4.8.26.tar.gz;
    sha256 = "0hcxh0kb6m0wk3apjhs57p7b171zzn63rg4l3nkcavygg5gx2mgp";
  };
  
  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if compat185 then "--enable-compat185" else "--disable-compat185")
  ];
  
}
