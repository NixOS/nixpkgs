{ stdenv, fetchurl, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libksba-1.2.0";

  src = fetchurl {
    url = "mirror://gnupg/libksba/${name}.tar.bz2";
    sha256 = "0jwk7hm3x3g4hd7l12z3d79dy7359x7lc88dq6z7q0ixn1jwxbq9";
  };

  propagatedBuildInputs = [libgpgerror];

  meta = {
    homepage = http://www.gnupg.org;
    description = "Libksba is a CMS and X.509 access library under development";
  };
}
