{ stdenv, fetchurl, file, libmhash, mlton, mysql, postgresql, sqlite }:

stdenv.mkDerivation rec {
  name = "urweb";
  version = "20100603";
  pname = "${name}-${version}";

  src = fetchurl {
    url = "http://www.impredicative.com/ur/${pname}.tgz";
    sha256 = "1f2l09g3586w0fyd7i7wkfnqlqwrk7c1q9pngmd8jz69g5ysl808";
  };

  buildInputs = [ stdenv.gcc file libmhash mlton mysql postgresql sqlite ];

  patches = [ ./remove-header-include-directory-prefix.patch ];

  postPatch = ''
    sed -e 's@/usr/bin/file@${file}/bin/file@g' -i configure
    sed -e 's@gcc @${stdenv.gcc}/bin/gcc @g' -i src/compiler.sml
    '';

  preConfigure =
    ''
      export GCCARGS="-I${mysql}/include -I${postgresql}/include -I${sqlite}/include -L${libmhash}/lib -L${mysql}/lib -L${postgresql}/lib -L${sqlite}/lib"
    '';

  meta = {
    description = "Ur/Web supports construction of dynamic web applications backed by SQL databases.";
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
    license = "bsd";
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
