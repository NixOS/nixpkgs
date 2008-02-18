args: with args;

stdenv.mkDerivation rec {
  name = "kdenetwork-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "0ykmrxhjkark82fbdvv8vx421h4lfzylas5jv4wx8z858dlx2rn1";
  };

  configureFlags = "-DWITH_telepathy=ON";
  propagatedBuildInputs = [kde4.pimlibs kde4.workspace kde4.support.qca
    kde4.decibel sqlite libidn avahi];
  buildInputs = [cmake];
}
