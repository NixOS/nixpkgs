{stdenv, fetchurl, cxxSupport ? true, compat185 ? true}:

stdenv.mkDerivation {
  name = "db4-4.4.16";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/db-4.4.16.NC.tar.gz;
    md5 = "1466026e67b5c3eb60c8c16b7f472c17";
  };
  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if cxxSupport then "--enable-compat185" else "--disable-compat185")
  ];
  patches = [./register.patch]; # <- should be fixed in 4.4.17
}
