{ stdenv, fetchurl, texinfo, perl }:

stdenv.mkDerivation rec {
  name = "glibc-info-2.9";
  
  src = fetchurl {
    url = http://nixos.org/tarballs/glibc-2.9-20081208.tar.bz2;
    sha256 = "0zhxbgcsl97pf349m0lz8d5ljvvzrcqc23yf08d888xlk4ms8m3h";
  };

  patches = [
    /* Support GNU Binutils 2.20 and above.  */
    ./binutils-2.20.patch
  ];

  preConfigure = ''
    export PWD_P=$(type -tP pwd)
    for i in configure io/ftwtest-sh; do
        # Can't use substituteInPlace here because replace hasn't been
        # built yet in the bootstrap.
        sed -i "$i" -e "s^/bin/pwd^$PWD_P^g"
    done
    mkdir ../build
    cd ../build
    
    configureScript=../$sourceRoot/configure
  '';

  configureFlags = [ "--enable-add-ons" ];

  buildInputs = [ texinfo perl ];

  buildPhase = "make info";

  # I don't know why the info is not generated in 'build'
  # Somehow building the info still does not work, because the final
  # libc.info hasn't a Top node.
  installPhase = ''
    mkdir -p $out/share/info
    cp ../$sourceRoot/manual/*.info $out/share/info
  '';

  meta = {
    homepage = http://www.gnu.org/software/libc/;
    description = "Locale information for the GNU C Library";
  };
}
