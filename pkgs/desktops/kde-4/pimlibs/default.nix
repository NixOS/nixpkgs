args: with args;

stdenv.mkDerivation rec {
  name = "kdepimlibs-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "0naqx0dwpabnxx1w498lnnypj369z5k5djnhwawlnlb9xmd1r7sw";
  };

  propagatedBuildInputs = [kde4.libs boost gpgme cyrus_sasl openldap];
  buildInputs = [cmake];
}
