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
  name = "python-2.4.6";
  majorVersion = "2.4";
  version = "2.4.6";

  src = fetchurl {
    url = http://www.python.org/ftp/python/2.4.6/Python-2.4.6.tar.bz2;
    sha256 = "021y88a4ki07dgq19yhg6zfvmncfiz7h5b2255438i9zmlwl246s";
  };

  patches = [
    # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
    ./search-path.patch
  ];

  inherit buildInputs;
  C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
  LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);

  configureFlags = "--enable-shared";

  preConfigure = ''
    # Purity.
    for i in /usr /sw /opt /pkg; do
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
  '';

  setupHook = ./setup-hook.sh;

  postInstall = ''
    rm -rf $out/lib/python2.4/test
  '';

  passthru = {
    inherit zlibSupport;
    libPrefix = "python2.4";
  };
}
