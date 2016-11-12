{ stdenv, fetchurl
, cxxSupport ? true
, compat185 ? true

# Options from inherited versions
, version, sha256
, extraPatches ? [ ]
, license ? stdenv.lib.licenses.sleepycat
, branch ? null
, drvArgs ? {}
}:

stdenv.mkDerivation (rec {
  name = "db-${version}";

  src = fetchurl {
    url = "http://download.oracle.com/berkeley-db/${name}.tar.gz";
    sha256 = sha256;
  };

  patches = extraPatches;

  # https://community.oracle.com/thread/3952592
  # this patch renames some sybols that conflict with libc++-3.8
  # symbols: atomic_compare_exchange, atomic_init, store
  prePatch = ''
    substituteInPlace src/dbinc/db.in \
      --replace '#define	store' '#define	store_db'

    substituteInPlace src/dbinc/atomic.h \
      --replace atomic_compare_exchange atomic_compare_exchange_db \
      --replace atomic_init atomic_init_db
    substituteInPlace src/mp/*.c \
      --replace atomic_compare_exchange atomic_compare_exchange_db \
      --replace atomic_init atomic_init_db
    substituteInPlace src/mutex/*.c \
      --replace atomic_compare_exchange atomic_compare_exchange_db \
      --replace atomic_init atomic_init_db
  '';

  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if compat185 then "--enable-compat185" else "--disable-compat185")
    "--enable-dbm"
    (stdenv.lib.optionalString stdenv.isFreeBSD "--with-pic")
  ];

  preConfigure = ''
    cd build_unix
    configureScript=../dist/configure
  '';

  postInstall = ''
    rm -rf $out/docs
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/index.html";
    description = "Berkeley DB";
    license = license;
    platforms = platforms.unix;
    branch = branch;
  };
} // drvArgs)
