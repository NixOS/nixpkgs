{ stdenv
, fetchurl
, aterm
}:
stdenv.mkDerivation {
  name = "sdf-library-1.1";

  src = fetchurl {
    url = http://www.meta-environment.org/releases/sdf-library-1.1.tar.gz;
    sha256 = "0dnv2f690s4q60bssavivganyalh7n966grcsb5hlb6z57gbaqp1";
  };

  buildInputs = [aterm];
}
