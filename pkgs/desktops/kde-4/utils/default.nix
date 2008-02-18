args: with args;

stdenv.mkDerivation rec {
  name = "kdeutils-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "1zp6czjxpjvqb3z81k45bv4pqb9pj4snc35xx8bnish829fhnncy";
  };

  propagatedBuildInputs = [kde4.workspace gmp libzip python libarchive];
  buildInputs = [cmake];
# TODO : tpctl
  patchPhase="fixCmakeDbusCalls";
}
