{ stdenv, fetchurl, file, openssl, mlton, mysql, postgresql, sqlite }:

stdenv.mkDerivation rec {
  pname = "urweb";
  version = "20130421";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.impredicative.com/ur/${name}.tgz";
    sha256 = "1dglcial9bzximw778wbfqx99khy34qpf9gw4bbncn9f742ji872";
  };

  buildInputs = [ stdenv.gcc file openssl mlton mysql postgresql sqlite ];

  prePatch = ''
    sed -e 's@/usr/bin/file@${file}/bin/file@g' -i configure
    '';

  preConfigure =
    ''
      export CC="${stdenv.gcc}/bin/gcc";
      export CCARGS="-I$out/include \
                      -L${mysql}/lib/mysql -L${postgresql}/lib -L${sqlite}/lib";

      export PGHEADER="${postgresql}/include/libpq-fe.h";
      export MSHEADER="${mysql}/include/mysql/mysql.h";
      export SQHEADER="${sqlite}/include/sqlite3.h";
    '';

  configureFlags = "--with-openssl=${openssl}"; 

  dontDisableStatic = true;

  meta = {
    description = "Construct dynamic web applications backed by SQL databases";
    longDescription = ''
      Ur is a programming language in the tradition of ML and Haskell, but
      featuring a significantly richer type system. Ur is functional, pure,
      statically-typed, and strict. Ur supports a powerful kind of
      metaprogramming based on row types.

      Ur/Web is Ur plus a special standard library and associated rules for
      parsing and optimization. Ur/Web supports construction of dynamic web
      applications backed by SQL databases. The signature of the standard
      library is such that well-typed Ur/Web programs "don't go wrong" in a
      very broad sense. Not only do they not crash during particular page
      generations, but they also may not:

      * Suffer from any kinds of code-injection attacks
      * Return invalid HTML
      * Contain dead intra-application links
      * Have mismatches between HTML forms and the fields expected by their handlers
      * Include client-side code that makes incorrect assumptions about the "AJAX"-style services that the remote web server provides
      * Attempt invalid SQL queries
      * Use improper marshaling or unmarshaling in communication with SQL databases or between browsers and web servers

      This type safety is just the foundation of the Ur/Web methodology. It is
      also possible to use metaprogramming to build significant application pieces
      by analysis of type structure. For instance, the demo includes an ML-style
      functor for building an admin interface for an arbitrary SQL table. The
      type system guarantees that the admin interface sub-application that comes
      out will always be free of the above-listed bugs, no matter which well-typed
      table description is given as input.

      The Ur/Web compiler also produces very efficient object code that does not use
      garbage collection. These compiled programs will often be even more efficient
      than what most programmers would bother to write in C. For example, the
      standalone web server generated for the demo uses less RAM than the bash shell.
      The compiler also generates JavaScript versions of client-side code, with no need
      to write those parts of applications in a different language.
    '';

    homepage = http://www.impredicative.com/ur/;
    license = stdenv.lib.licenses.bsd3;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
