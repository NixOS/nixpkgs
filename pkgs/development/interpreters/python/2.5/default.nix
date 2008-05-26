{stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2,
 gdbmSupport ? true, gdbm ? null
 , sqlite ? null
 , db4 ? null
 , readline ? null
 , openssl ? null
 }:

assert zlibSupport -> zlib != null;
assert gdbmSupport -> gdbm != null;

with stdenv.lib;

let

  buildInputs =
    optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc ++
    [bzip2]
    ++ optional zlibSupport zlib
    ++ optional gdbmSupport gdbm
    ++ optional (sqlite != null) sqlite
    ++ optional (db4 != null) db4
    ++ optional (readline != null) readline
    ++ optional (openssl != null) openssl
    ;

in

stdenv.mkDerivation {
  name = "python-2.5.2";
  
  src = fetchurl {
    url = http://www.python.org/ftp/python/2.5.2/Python-2.5.2.tar.bz2;
    sha256 = "0gh8bvs56vdv8qmlfmiwyczjpldj0y3zbzd0zyhyjfd0c8m0xy7j";
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
  " + (if readline != null then ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lncurses"
  '' else "");
  
  postInstall = "
    ensureDir $out/nix-support
    cp ${./setup-hook.sh} $out/nix-support/setup-hook
    rm -rf $out/lib/python2.5/test
  ";

  passthru = {
    inherit zlibSupport;
    sqliteSupport = sqlite != null;
    db4Support = db4 != null;
    readlineSupport = readline != null;
    opensslSupport = openssl != null;
    libPrefix = "python2.5";
  };
}
