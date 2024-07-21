{ stdenv, lib, fetchurl, updateAutotoolsGnuConfigScriptsHook }:

stdenv.mkDerivation rec {
  pname = "gdbm";
  version = "1.23";

  src = fetchurl {
    url = "mirror://gnu/gdbm/${pname}-${version}.tar.gz";
    sha256 = "sha256-dLEIHSH/8TrkvXwW5dblBKTCb3zeHcoNljpIQXS7ys0=";
  };

  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];

  doCheck = true; # not cross;

  # Linking static stubs on cygwin requires correct ordering.
  # Consider upstreaming this.

  # Disable dbmfetch03.at test because it depends on unlink()
  # failing on a link in a chmod -w directory, which cygwin
  # apparently allows.
  postPatch = lib.optionalString stdenv.buildPlatform.isCygwin ''
      substituteInPlace tests/Makefile.in --replace \
        '_LDADD = ../src/libgdbm.la ../compat/libgdbm_compat.la' \
        '_LDADD = ../compat/libgdbm_compat.la ../src/libgdbm.la'
      substituteInPlace tests/testsuite.at --replace \
        'm4_include([dbmfetch03.at])' ""
  '';

  enableParallelBuilding = true;
  configureFlags = [ "--enable-libgdbm-compat" ];

  # create symlinks for compatibility
  postInstall = ''
    install -dm755 $out/include/gdbm
    (
      cd $out/include/gdbm
      ln -s ../gdbm.h gdbm.h
      ln -s ../ndbm.h ndbm.h
      ln -s ../dbm.h  dbm.h
    )
  '';

  meta = with lib; {
    description = "GNU dbm key/value database library";
    longDescription = ''
       GNU dbm (or GDBM, for short) is a library of database functions that
       use extensible hashing and work similar to the standard UNIX dbm.
       These routines are provided to a programmer needing to create and
       manipulate a hashed database.

       The basic use of GDBM is to store key/data pairs in a data file.
       Each key must be unique and each key is paired with only one data
       item.

       The library provides primitives for storing key/data pairs,
       searching and retrieving the data by its key and deleting a key
       along with its data.  It also support sequential iteration over all
       key/data pairs in a database.

       For compatibility with programs using old UNIX dbm function, the
       package also provides traditional dbm and ndbm interfaces.
      '';
    homepage = "https://www.gnu.org/software/gdbm/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vrthra ];
  };
}
