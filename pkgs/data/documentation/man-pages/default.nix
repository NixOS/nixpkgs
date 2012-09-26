{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.42";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.xz";
    sha256 = "11kh0ifzqbxk797lq037ixqhpf6h90w9xxygzh796mddg4rr4s9j";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
  };
}
