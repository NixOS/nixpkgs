{ fetchurl, stdenv, makeWrapper, gnum4, texinfo, texLive, automake,
  enableX11 ? false, xlibsWrapper ? null }:

let
  version = "9.2";
  bootstrapFromC = ! (stdenv.isi686 || stdenv.isx86_64);

  arch = if      stdenv.isi686   then "-i386"
         else if stdenv.isx86_64 then "-x86-64"
         else                         "";
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
      sha256 = "1fmlpnhf5a75db93phajh4ysbdgrgl72v45lk3kznriprl0a7jc6";
    } else if stdenv.isx86_64
    then fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-${version}-x86-64.tar.gz";
      sha256 = "1skzxxhr0iq96bf0j5m7mvf3i4sppfyfa6gpqn34mwgkw1fx8274";
    } else fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-c-${version}.tar.gz";
      sha256 = "0w5ib5vsidihb4hb6fma3sp596ykr8izagm57axvgd6lqzwicsjg";
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

  meta = with stdenv.lib; {
    description = "MIT/GNU Scheme, a native code Scheme compiler";

    longDescription =
      '' MIT/GNU Scheme is an implementation of the Scheme programming
         language, providing an interpreter, compiler, source-code debugger,
         integrated Emacs-like editor, and a large runtime library.  MIT/GNU
         Scheme is best suited to programming large applications with a rapid
         development cycle.
      '';

    homepage = https://www.gnu.org/software/mit-scheme/;

    license = licenses.gpl2Plus;

    maintainers = [ ];

    # Build fails on Cygwin and Darwin:
    # <http://article.gmane.org/gmane.lisp.scheme.mit-scheme.devel/489>.
    platforms = platforms.gnu ++ platforms.linux ++ platforms.freebsd;
  };
}
