{
  lib,
  stdenv,
  fetchurl,
  gawk,
  undmg,
  cpio,
  xar,
  fetchFromGitLab,
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
  version = "3.2.4";
  pname = "fpc";

  src = fetchFromGitLab {
    owner = "freepascal.org/fpc";
    repo = "source";
    tag = "release_3_2_4_rc1";
    hash = "sha256-1TOQuHtI6/t/iCR6c7gNkLRZ7cdliTTVt66X+a60orc=";
  };

  buildInputs = [
    startFPC
    gawk
  ];

  glibc = stdenv.cc.libc.out;

  # Patch paths for linux systems. Other platforms will need their own patches.
  patches = [
    ./mark-paths.patch # mark paths for later substitution in postPatch
  ]
  ++ lib.optional (
    stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin
  ) ./darwin-aarch64-no-fpcr-exception-traps.patch;

  postPatch = ''
    # substitute the markers set by the mark-paths patch
    substituteInPlace fpcsrc/compiler/systems/t_linux.pas --subst-var-by dynlinker-prefix "${glibc}"
    substituteInPlace fpcsrc/compiler/systems/t_linux.pas --subst-var-by syslibpath "${glibc}/lib"

    substituteInPlace fpcsrc/compiler/systems/t_darwin.pas \
      --replace-fail "LibrarySearchPath.AddLibraryPath(sysrootpath,'=/usr/lib',true)" "LibrarySearchPath.AddLibraryPath(sysrootpath,'$SDKROOT/usr/lib',true)"

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

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # SYSROOTPATH prevents the Makefile from hardcoding /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
    export SYSROOTPATH="$SDKROOT"

    NIX_LDFLAGS="-syslibroot $SDKROOT -L${lib.getLib libiconv}/lib"
  '';

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

  meta = {
    description = "Free Pascal Compiler from a source distribution";
    homepage = "https://www.freepascal.org";
    maintainers = [ lib.maintainers.raskin ];
    license = with lib.licenses; [
      gpl2
      lgpl2
    ];
    platforms = lib.platforms.unix;
    # See:
    # * <https://gitlab.com/freepascal.org/fpc/source/-/issues/41045>
    # * <https://gitlab.com/freepascal.org/fpc/source/-/merge_requests/887>
    broken = stdenv.cc.isClang && stdenv.hostPlatform.isx86_64;
  };
}
