{ fetchurl, stdenv }:

let version = "9.0.1"; in
stdenv.mkDerivation {
  name = "mit-scheme-${version}";

  src = fetchurl {
    url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-c-${version}.tar.gz";
    sha256 = "1g2mifrx0bvag0hlrbk81rkrlm1pbn688zw8b9d2i0sl5g2p1ril";
  };

  preConfigure = "cd src";
  buildPhase = "./etc/make-liarc.sh --prefix=$out";

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
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
