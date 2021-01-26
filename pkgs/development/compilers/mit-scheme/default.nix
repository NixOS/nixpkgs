{ fetchurl, lib, stdenv, makeWrapper, gnum4, texinfo, texLive, automake,
  enableX11 ? false, xlibsWrapper ? null }:

let
  version = "10.1.10";
  bootstrapFromC = ! (stdenv.isi686 || stdenv.isx86_64);

  arch = if      stdenv.isi686   then "-i386"
         else                         "-x86-64";
in
stdenv.mkDerivation {
  name = if enableX11 then "mit-scheme-x11-${version}" else "mit-scheme-${version}";

  # MIT/GNU Scheme is not bootstrappable, so it's recommended to compile from
  # the platform-specific tarballs, which contain pre-built binaries.  It
  # leads to more efficient code than when building the tarball that contains
  # generated C code instead of those binaries.
  src =
    if stdenv.isi686
    then fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-${version}-i386.tar.gz";
      sha256 = "117lf06vcdbaa5432hwqnskpywc6x8ai0gj99h480a4wzkp3vhy6";
  } else fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-${version}-x86-64.tar.gz";
      sha256 = "1rljv6iddrbssm91c0nn08myj92af36hkix88cc6qwq38xsxs52g";
    };

  buildInputs = if enableX11 then [xlibsWrapper] else [];

  configurePhase =
    '' (cd src && ./configure)
       (cd doc && ./configure)
    '';

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
    '' make prefix=$out install -C src
       make prefix=$out install -C doc
    '';

  fixupPhase =
    '' wrapProgram $out/bin/mit-scheme${arch} --set MITSCHEME_LIBRARY_PATH \
         $out/lib/mit-scheme${arch}
    '';

  nativeBuildInputs = [ makeWrapper gnum4 texinfo texLive automake ];

  # XXX: The `check' target doesn't exist.
  doCheck = false;

  meta = with lib; {
    description = "MIT/GNU Scheme, a native code Scheme compiler";

    longDescription =
      '' MIT/GNU Scheme is an implementation of the Scheme programming
         language, providing an interpreter, compiler, source-code debugger,
         integrated Emacs-like editor, and a large runtime library.  MIT/GNU
         Scheme is best suited to programming large applications with a rapid
         development cycle.
      '';

    homepage = "https://www.gnu.org/software/mit-scheme/";

    license = licenses.gpl2Plus;

    maintainers = [ ];

    # Build fails on Cygwin and Darwin:
    # <http://article.gmane.org/gmane.lisp.scheme.mit-scheme.devel/489>.
    platforms = platforms.gnu ++ platforms.linux ++ platforms.freebsd;
  };
}
