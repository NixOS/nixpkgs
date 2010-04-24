{ fetchurl, stdenv, gnum4 }:

let
  version = "9.0.1";
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
      sha256 = "0cfj3bawjdnpa7cbqh2f23hfpjpmryypmzkhndvdbi79a65fl0n2";
    } else if stdenv.isx86_64
    then fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-${version}-x86-64.tar.gz";
      sha256 = "0p188d7n0iqdgvra6qv5apvcsv0z2p97ry7xz5216zkc364i6mmr";
    } else fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-c-${version}.tar.gz";
      sha256 = "1g2mifrx0bvag0hlrbk81rkrlm1pbn688zw8b9d2i0sl5g2p1ril";
    };

  preConfigure = "cd src";
  buildPhase =
    if bootstrapFromC
    then "./etc/make-liarc.sh --prefix=$out"
    else "make compile-microcode";

  buildInputs = [ gnum4 ];

  patches =
    stdenv.lib.optional (stdenv.system == "i686-cygwin") ./ucontext-cygwin.patch;

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
    platforms = stdenv.lib.platforms.all;
  };
}
