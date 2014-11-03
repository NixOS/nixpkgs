{ fetchurl, stdenv, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "tokyocabinet-1.4.46";

  src = fetchurl {
    url = "http://www.1978th.net/tokyocabinet/${name}.tar.gz";
    sha256 = "18rkv6kq43cqabc9mvfw534nsv6v8bc2i2r2bmax0yxnbhqa7ahf";
  };

  buildInputs = [ zlib bzip2 ];

  doCheck = true;

  postInstall =
    '' sed -i "$out/lib/pkgconfig/tokyocabinet.pc" \
           -e 's|-lz|-L${zlib}/lib -lz|g;
               s|-lbz2|-L${bzip2}/lib -lbz2|g'
    '';

  meta = {
    description = "Tokyo Cabinet: a modern implementation of DBM";

    longDescription =
      '' Tokyo Cabinet is a library of routines for managing a database. The
         database is a simple data file containing records, each is a pair of
         a key and a value.  Every key and value is serial bytes with
         variable length.  Both binary data and character string can be used
         as a key and a value.  There is neither concept of data tables nor
         data types.  Records are organized in hash table, B+ tree, or
         fixed-length array.

         Tokyo Cabinet is developed as the successor of GDBM and QDBM on the
         following purposes.  They are achieved and Tokyo Cabinet replaces
         conventional DBM products: improves space efficiency, improves time
         efficiency, improves parallelism, improves usability, improves
         robustness, supports 64-bit architecture.
      '';

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
