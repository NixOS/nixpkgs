{ lib, stdenv, fetchurl

, doCheck ? true # test suite depends on dejagnu which cannot be used during bootstrapping
, dejagnu
}:

stdenv.mkDerivation rec {
  pname = "libffi";
  version = "3.3";

  src = fetchurl {
    url = "https://github.com/libffi/libffi/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-cvunkicD3fp6Ao1ROsFahcjVTI1n9V+lpIAohdxlIFY=";
  };

  patches = [];

  outputs = [ "out" "dev" "man" "info" ];

  configureFlags = [
    "--with-gcc-arch=generic" # no detection of -march= or -mtune=
    "--enable-pax_emutramp"

    # Causes issues in downstream packages which misuse ffi_closure_alloc
    # Reenable once these issues are fixed and merged:
    # https://gitlab.haskell.org/ghc/ghc/-/merge_requests/6155
    # https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/283
    "--disable-exec-static-tramp"
  ];

  # with fortify3, tests fail for some reason
  hardeningDisable = [ "fortify3" ];

  preCheck = ''
    # The tests use -O0 which is not compatible with -D_FORTIFY_SOURCE.
    NIX_HARDENING_ENABLE=''${NIX_HARDENING_ENABLE/fortify/}
  '';

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform; # Don't run the native `strip' when cross-compiling.

  inherit doCheck;

  nativeCheckInputs = [ dejagnu ];

  meta = with lib; {
    description = "A foreign function call interface library";
    longDescription = ''
      The libffi library provides a portable, high level programming
      interface to various calling conventions.  This allows a
      programmer to call any function specified by a call interface
      description at run-time.

      FFI stands for Foreign Function Interface.  A foreign function
      interface is the popular name for the interface that allows code
      written in one language to call code written in another
      language.  The libffi library really only provides the lowest,
      machine dependent layer of a fully featured foreign function
      interface.  A layer must exist above libffi that handles type
      conversions for values passed between the two languages.
    '';
    homepage = "http://sourceware.org/libffi/";
    license = licenses.mit;
    maintainers = with maintainers; [ armeenm ];
    platforms = platforms.all;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
