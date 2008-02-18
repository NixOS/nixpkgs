args: with args;

stdenv.mkDerivation rec {
  name = "kdetoys-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "0jvmjbnc79adgf7g70s1vz2lvwpl6fx2520lmzc6pnrvl0qhcs4i";
  };

  propagatedBuildInputs = [kde4.workspace];
  buildInputs = [cmake];
}
