{stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2}:

assert zlibSupport -> zlib != null;

with stdenv.lib;

let

  buildInputs =
    optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc ++
    [bzip2] ++ 
    optional zlibSupport zlib;

in

stdenv.mkDerivation {
  name = "python-2.5.1";
  
  src = fetchurl {
    url = http://www.python.org/ftp/python/2.5.1/Python-2.5.1.tar.bz2;
    sha256 = "0rz1279q0i5f69jvwn6i0vlxmhxgcfykxnr80zmx4micw3fd9dfh";
  };

  patches = [
    # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
    ./search-path.patch
  ];
  
  inherit buildInputs;
  C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
  LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
  
  configureFlags = "--enable-shared --with-wctype-functions";
  
  preConfigure = "
    # Purity.
    for i in /usr /sw /opt /pkg; do 
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
  ";
  
  postInstall = "
    ensureDir $out/nix-support
    cp ${./setup-hook.sh} $out/nix-support/setup-hook
    rm -rf $out/lib/python2.5/test
  ";

  passthru = {
    inherit zlibSupport;
    libPrefix = "python2.5";
  };
}
