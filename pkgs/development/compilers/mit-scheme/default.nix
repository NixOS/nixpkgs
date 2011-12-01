{ fetchurl, stdenv, gnum4, texinfo, texLive, automake }:

let
  version = "9.1.1";
  bootstrapFromC = ! (stdenv.isi686 || stdenv.isx86_64);
in
stdenv.mkDerivation {
  name = "mit-scheme-${version}";

  # MIT/GNU Scheme is not bootstrappable, so it's recommended to compile from
  # the platform-specific tarballs, which contain pre-built binaries.  It
  # leads to more efficient code than when building the tarball that contains
  # generated C code instead of those binaries.
  src =
    if stdenv.isi686
    then fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-${version}-i386.tar.gz";
      sha256 = "1bigzzk0k08lggyzqp4rmyvbqhhs3ld4c7drfp22d5qnkbvvzh4g";
    } else if stdenv.isx86_64
    then fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-${version}-x86-64.tar.gz";
      sha256 = "1l4zxqm5r1alc6y1cky62rn8h6i40qyiba081n6phwypwxr5sd0g";
    } else fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-c-${version}.tar.gz";
      sha256 = "1661cybycfvjjyq92gb3n1cygxfmfjdhnh3d2ha3vy6xxk9d7za9";
    };

  buildPhase =
    '' cd src
       ${if bootstrapFromC
         then "./etc/make-liarc.sh --prefix=$out"
         else "make compile-microcode"}

       cd ../doc

       # Provide a `texinfo.tex'.
       export TEXINPUTS="$(echo ${automake}/share/automake-*)"
       echo "\$TEXINPUTS is \`$TEXINPUTS'"
       make

       cd ..
    '';

  installPhase =
    '' make install -C src
       make install -C doc
    '';

  buildNativeInputs = [ gnum4 texinfo texLive automake ];

  # XXX: The `check' target doesn't exist.
  doCheck = false;

  meta = {
    description = "MIT/GNU Scheme, a native code Scheme compiler";

    longDescription =
      '' MIT/GNU Scheme is an implementation of the Scheme programming
         language, providing an interpreter, compiler, source-code debugger,
         integrated Emacs-like editor, and a large runtime library.  MIT/GNU
         Scheme is best suited to programming large applications with a rapid
         development cycle.
      '';

    homepage = http://www.gnu.org/software/mit-scheme/;

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];

    # Build fails on Cygwin and Darwin:
    # <http://article.gmane.org/gmane.lisp.scheme.mit-scheme.devel/489>.
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.freebsd;
  };
}
