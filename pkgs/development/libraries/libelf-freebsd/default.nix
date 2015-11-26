{ fetchsvn, stdenv }:

stdenv.mkDerivation (rec {
  version = "3258";
  name = "libelf-freebsd-${version}";

  #src = fetchurl {
  #  url = "http://sourceforge.net/code-snapshots/svn/e/el/elftoolchain/code/elftoolchain-code-${version}-trunk.zip";
  #  sha256 = "0vf7s9dwk2xkmhb79aigqm0x0yfbw1j0b9ksm51207qwr179n6jr";
  #};
  src = fetchsvn {
    url = svn://svn.code.sf.net/p/elftoolchain/code/trunk ;
    rev = 3258;
  };

  doCheck = true;
  
  meta = {
    description = "Essential compilation tools and libraries for building and analyzing ELF based program images";

    homepage = https://sourceforge.net/p/elftoolchain/wiki/Home/;

    license = stdenv.lib.licenses.bsd2;

    platforms = stdenv.lib.platforms.freebsd;
    maintainers = [ ];
  };
})
