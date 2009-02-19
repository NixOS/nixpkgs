{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gprolog-1.3.1";

  src = fetchurl {
    urls = [
      "mirror://gnu/gprolog/${name}.tar.gz"
      "http://www.gprolog.org/${name}.tar.gz"
    ];
    sha256 = "05n3k0yynzvpc1ir1nw5bwm6m3ail0a0r1vqdsh4fii3kndiacrw";
  };

  configurePhase = "cd src ;"
    + "./configure --prefix=$out "
    + "--with-install-dir=$out/share/${name} "
    + "--with-examples-dir=$out/share/doc/${name}/examples "
    + "--with-doc-dir=$out/share/doc/${name}";

  doCheck = true;

  postInstall = ''
    ln -vs "$out/share/${name}/include" "$out/include"
  '';

  meta = {
    homepage = http://www.gnu.org/software/gprolog/;

    description = "GNU Prolog, a free Prolog compiler with constraint solving over finite domains";

    longDescription = ''
      GNU Prolog is a free Prolog compiler with constraint solving
      over finite domains developed by Daniel Diaz.

      GNU Prolog accepts Prolog+constraint programs and produces
      native binaries (like gcc does from a C source).  The obtained
      executable is then stand-alone.  The size of this executable can
      be quite small since GNU Prolog can avoid to link the code of
      most unused built-in predicates.  The performances of GNU Prolog
      are very encouraging (comparable to commercial systems).

      Beside the native-code compilation, GNU Prolog offers a
      classical interactive interpreter (top-level) with a debugger.

      The Prolog part conforms to the ISO standard for Prolog with
      many extensions very useful in practice (global variables, OS
      interface, sockets,...).

      GNU Prolog also includes an efficient constraint solver over
      Finite Domains (FD).  This opens contraint logic programming to
      the user combining the power of constraint programming to the
      declarativity of logic programming.
    '';

    license = "GPLv2+";
  };
}
