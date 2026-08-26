{
  lib,
  stdenv,
  gawk,
  fetchFromGitLab,
  libiconv,
  callPackage,
}:

let
  startFPC = callPackage ./binary.nix { };
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

  # Darwin/AArch64: SysInitFPU enables FPCR exception traps, but AppKit
  # executes FP ops that trap during NSWindow init. CLEAR the trap-enable
  # bits after setting them. is equivalent to calling Math.SetExceptionMask.
  patches = lib.optional (
    stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin
  ) ./darwin-aarch64-no-fpcr-exception-traps.patch;

  postPatch = ''
    substituteInPlace compiler/systems/t_darwin.pas \
      --replace-fail "LibrarySearchPath.AddLibraryPath(sysrootpath,'=/usr/lib',true)" "LibrarySearchPath.AddLibraryPath(sysrootpath,'$SDKROOT/usr/lib',true)"

    # Replace the `codesign --remove-signature` command with a custom script, since `codesign` is not available
    # in nixpkgs
    # Remove the -no_uuid strip flag which does not work on llvm-strip, only
    # Apple strip.
    substituteInPlace compiler/Makefile \
      --replace-fail \
        "\$(CODESIGN) --remove-signature" \
        "${./remove-signature.sh}" \
      --replace-fail "ifneq (\$(CODESIGN),)" "ifeq (\$(OS_TARGET), darwin)" \
      --replace-fail "-no_uuid" ""
  '';

  # fpmake.pp is the only compilation that runs without -n (skip-config), so it reads
  # fpc.cfg from the compiler's directory. Writing the glibc paths there gives fpmake
  # the correct ELF interpreter BEFORE it is executed
  preBuild = lib.optionalString stdenv.hostPlatform.isLinux ''
    printf '%s\n' \
      "-Fl${stdenv.cc.libc.out}/lib" \
      "-Xd${stdenv.cc.bintools.dynamicLinker}" \
      > compiler/fpc.cfg
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
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Point the installed compiler to glibc in the Nix store via fpc.cfg.
    for cfg in "$out/lib/fpc/etc/fpc.cfg" "$out/etc/fpc.cfg"; do
      printf "%s\n" \
        "-Fl${stdenv.cc.libc.out}/lib" \
        "-Xd${stdenv.cc.libc.out}/lib/$(cd "${stdenv.cc.libc.out}/lib" && echo ld-linux*.so.*)" \
        >> "$cfg"
    done
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
