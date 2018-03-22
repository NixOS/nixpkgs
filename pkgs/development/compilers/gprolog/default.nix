{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gprolog-1.4.4";

  src = fetchurl {
    urls = [
      "mirror://gnu/gprolog/${name}.tar.gz"
      "http://www.gprolog.org/${name}.tar.gz"
    ];
    sha256 = "13miyas47bmijmadm68cbvb21n4s156gjafz7kfx9brk9djfkh0q";
  };

  hardeningDisable = stdenv.lib.optional stdenv.isi686 "pic";

  patchPhase = ''
    sed -i -e "s|/tmp/make.log|$TMPDIR/make.log|g" src/Pl2Wam/check_boot
  '';

  preConfigure = ''
    cd src
    configureFlagsArray=(
      "--with-install-dir=$out"
      "--without-links-dir"
      "--with-examples-dir=$out/share/${name}/examples"
      "--with-doc-dir=$out/share/${name}/doc"
    )
  '';

  postInstall = ''
    mv -v $out/[A-Z]* $out/gprolog.ico $out/share/${name}/
  '';

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/gprolog/;
    description = "GNU Prolog, a free Prolog compiler with constraint solving over finite domains";
    license = stdenv.lib.licenses.lgpl3Plus;

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

    maintainers = [ stdenv.lib.maintainers.peti ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
