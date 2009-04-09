args: with args;

stdenv.mkDerivation {
  name = "atlas-3.9.9";
  src = fetchurl {
    url = http://kent.dl.sourceforge.net/sourceforge/math-atlas/atlas3.9.9.tar.bz2;
    sha256 = "0apbiqr0hlb38mrnlij0szsraxvxqfqainmp59xqj94pndx5s3yk";
  };

  # configure outside of the source directory
  preConfigure = '' mkdir build; cd build; configureScript=../configure; '';

  NIX_CFLAGS_COMPILE = if stdenv.system == "x86_64-linux" then "-fPIC" else "";

  buildInputs = [gfortran];

  meta = {
    description     = "Atlas library";
    license     = "GPL";
    homepage    = http://math-atlas.sourceforge.net/;
  };
}
