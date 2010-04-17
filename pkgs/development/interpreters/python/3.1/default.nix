{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2
, gdbmSupport ? true, gdbm ? null
, sqlite ? null
, db4 ? null
, readline ? null
, openssl ? null
, tk ? null
, tcl ? null
, libX11 ? null
, xproto ? null
, arch ? null
, sw_vers ? null
}:

# I haven't spend much time on this derivation. So some of these settings may not apply to python-3.1
# 

assert zlibSupport -> zlib != null;
assert gdbmSupport -> gdbm != null;
assert stdenv.isDarwin -> arch != null;
assert stdenv.isDarwin -> sw_vers != null;

with stdenv.lib;

let

  majorVersion = "3.1";
  version = "${majorVersion}.1";

  buildInputs =
    optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc ++
    [bzip2]
    ++ optional zlibSupport zlib
    ++ optional gdbmSupport gdbm
    ++ optional (sqlite != null) sqlite
    ++ optional (db4 != null) db4
    ++ optional (readline != null) readline
    ++ optional (openssl != null) openssl
    ++ optional (tk != null) tk
    ++ optional (tcl != null) tcl
    ++ optional (libX11 != null) libX11
    ++ optional (xproto != null) xproto
    ++ optional (arch != null) arch
    ++ optional (sw_vers != null) sw_vers
    ;

in

stdenv.mkDerivation ( {
  name = "python-${version}";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/${version}/Python-${version}.tar.bz2";
    sha256 = "1zai7damkpbzwgflrm3rc9r024kb2iiqwasb2b0kmpmsi9bw4z6q";
  };

  patches = [
    # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
    ./search-path.patch
  ];

  inherit buildInputs;
  C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") buildInputs);
  LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
  configureFlags = "--enable-shared --with-threads --enable-unicode --with-wctype-functions";

  preConfigure = ''
    # Purity.
    for i in /usr /sw /opt /pkg; do
      substituteInPlace ./setup.py --replace $i /no-such-path
    done
  '' + (if readline != null then ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lncurses"
  '' else "");

  setupHook = ./setup-hook.sh;

  postInstall = ''
    rm -rf "$out/lib/python${majorVersion}/test"
  '';

  passthru = {
    inherit zlibSupport;
    sqliteSupport = sqlite != null;
    db4Support = db4 != null;
    readlineSupport = readline != null;
    opensslSupport = openssl != null;
    tkSupport = (tk != null) && (tcl != null);
    libPrefix = "python${majorVersion}";
  };

  meta = {
    platforms = stdenv.lib.platforms.all;
  };
} // (if stdenv.isDarwin then { NIX_CFLAGS_COMPILE = "-msse2" ; patches = [./search-path.patch]; } else {} ) )
