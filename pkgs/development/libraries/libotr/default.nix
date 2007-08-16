{stdenv, fetchurl, libgcrypt}:

stdenv.mkDerivation {
  name = "libotr-3.1.0";
  src = fetchurl {
    url = http://www.cypherpunks.ca/otr/libotr-3.1.0.tar.gz;
    sha256 = "1x3y5nvqcg9a0lx630cvkjpwv7mmwxpy4pcjfm6fbiqylaxn05bj";
  };

  buildInputs = [libgcrypt];
}
