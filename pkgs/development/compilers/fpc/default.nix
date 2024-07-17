{
  lib,
  stdenv,
  fetchurl,
  gawk,
  fetchpatch,
  undmg,
  cpio,
  xar,
  darwin,
  libiconv,
}:

let
  startFPC = import ./binary.nix {
    inherit
      stdenv
      fetchurl
      undmg
      cpio
      xar
      lib
      ;
  };
in

stdenv.mkDerivation rec {
  version = "3.2.2";
  pname = "fpc";

  src = fetchurl {
    url = "mirror://sourceforge/freepascal/fpcbuild-${version}.tar.gz";
    sha256 = "85ef993043bb83f999e2212f1bca766eb71f6f973d362e2290475dbaaf50161f";
  };

  buildInputs =
    [
      startFPC
      gawk
    ]
    ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.CoreFoundation
    ];

  glibc = stdenv.cc.libc.out;

  # Patch paths for linux systems. Other platforms will need their own patches.
  patches =
    [
      ./mark-paths.patch # mark paths for later substitution in postPatch
    ]
    ++ lib.optional stdenv.isAarch64 (fetchpatch {
      # backport upstream patch for aarch64 glibc 2.34
      url = "https://gitlab.com/freepascal.org/fpc/source/-/commit/a20a7e3497bccf3415bf47ccc55f133eb9d6d6a0.patch";
      hash = "sha256-xKTBwuOxOwX9KCazQbBNLhMXCqkuJgIFvlXewHY63GM=";
      stripLen = 1;
      extraPrefix = "fpcsrc/";
    });

  postPatch = ''
    # substitute the markers set by the mark-paths patch
    substituteInPlace fpcsrc/compiler/systems/t_linux.pas --subst-var-by dynlinker-prefix "${glibc}"
    substituteInPlace fpcsrc/compiler/systems/t_linux.pas --subst-var-by syslibpath "${glibc}/lib"
    # Replace the `codesign --remove-signature` command with a custom script, since `codesign` is not available
    # in nixpkgs
    # Remove the -no_uuid strip flag which does not work on llvm-strip, only
    # Apple strip.
    substituteInPlace fpcsrc/compiler/Makefile \
      --replace \
        "\$(CODESIGN) --remove-signature" \
        "${./remove-signature.sh}" \
      --replace "ifneq (\$(CODESIGN),)" "ifeq (\$(OS_TARGET), darwin)" \
      --replace "-no_uuid" ""
  '';

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; "-F${CoreFoundation}/Library/Frameworks"
  );

  makeFlags = [
    "NOGDB=1"
    "FPC=${startFPC}/bin/fpc"
  ];

  installFlags = [ "INSTALL_PREFIX=\${out}" ];

  postInstall = ''
    for i in $out/lib/fpc/*/ppc*; do
      ln -fs $i $out/bin/$(basename $i)
    done
    mkdir -p $out/lib/fpc/etc/
    $out/lib/fpc/*/samplecfg $out/lib/fpc/${version} $out/lib/fpc/etc/

    # Generate config files in /etc since on darwin, ppc* does not follow symlinks
    # to resolve the location of /etc
    mkdir -p $out/etc
    $out/lib/fpc/*/samplecfg $out/lib/fpc/${version} $out/etc
  '';

  passthru = {
    bootstrap = startFPC;
  };

  meta = with lib; {
    description = "Free Pascal Compiler from a source distribution";
    homepage = "https://www.freepascal.org";
    maintainers = [ maintainers.raskin ];
    license = with licenses; [
      gpl2
      lgpl2
    ];
    platforms = platforms.unix;
  };
}
