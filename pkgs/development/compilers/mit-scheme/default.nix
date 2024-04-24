{ fetchurl
, lib
, stdenv
, makeWrapper
, gnum4
, texinfo
, texliveSmall
, automake
, autoconf
, libtool
, ghostscript
, ncurses
, enableX11 ? false, libX11
}:

let
  version = "12.1";
  bootstrapFromC = ! ((stdenv.isLinux && stdenv.isAarch64) || stdenv.isx86_64);

  arch = if stdenv.isLinux && stdenv.isAarch64 then
    "-aarch64le"
   else
     "-x86-64";
in
stdenv.mkDerivation {
  pname = "mit-scheme" + lib.optionalString enableX11 "-x11";
  inherit version;

  # MIT/GNU Scheme is not bootstrappable, so it's recommended to compile from
  # the platform-specific tarballs, which contain pre-built binaries.  It
  # leads to more efficient code than when building the tarball that contains
  # generated C code instead of those binaries.
  src =
    if stdenv.isLinux && stdenv.isAarch64
    then fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-${version}-aarch64le.tar.gz";
      sha256 = "12ra9bc93x8g07impbd8jr6djjzwpb9qvh9zhxvvrba3332zx3vh";
  } else fetchurl {
      url = "mirror://gnu/mit-scheme/stable.pkg/${version}/mit-scheme-${version}-x86-64.tar.gz";
      sha256 = "035f92vni0vqmgj9hq2i7vwasz7crx52wll4823vhfkm1qdv5ywc";
    };

  buildInputs = [ ncurses ] ++ lib.optionals enableX11 [ libX11 ];

  configurePhase = ''
    runHook preConfigure
    (cd src && ./configure)
    (cd doc && ./configure)
    runHook postConfigure
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=array-parameter"
    "-Wno-error=use-after-free"
  ];

  buildPhase = ''
    runHook preBuild
    cd src

   ${if bootstrapFromC
      then "./etc/make-liarc.sh --prefix=$out"
      else "make compile-microcode"}

    cd ../doc

    make

    cd ..

    runHook postBuild
  '';


  installPhase = ''
    runHook preInstall
    make prefix=$out install -C src
    make prefix=$out install -C doc
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/mit-scheme${arch}-${version} --set MITSCHEME_LIBRARY_PATH \
      $out/lib/mit-scheme${arch}-${version}
  '';

  nativeBuildInputs = [ makeWrapper gnum4 texinfo (texliveSmall.withPackages (ps: with ps; [ epsf ps.texinfo ])) automake ghostscript autoconf libtool ];

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
