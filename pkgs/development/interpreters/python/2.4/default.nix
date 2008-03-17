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
  name = "python-2.4.4";
  
  src = fetchurl {
    url = http://www.python.org/ftp/python/2.4.4/Python-2.4.4.tar.bz2;
    md5 = "0ba90c79175c017101100ebf5978e906";
  };

  patches = [
    # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
    ./search-path.patch
  ];
  
  inherit buildInputs;
  C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
  LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
  
  configureFlags = "--enable-shared";
  
  preConfigure = "
    # Purity.
    for i in /usr /sw /opt /pkg; do 
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
  ";
  
  postInstall = "
    ensureDir $out/nix-support
    cp ${./setup-hook.sh} $out/nix-support/setup-hook
    rm -rf $out/lib/python2.4/test
  ";

  passthru = {
    inherit zlibSupport;
    libPrefix = "python2.4";
  };
}
