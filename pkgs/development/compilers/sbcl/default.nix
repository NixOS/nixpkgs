{
  lib,
  stdenv,
  callPackage,
  ecl,
  coreutils,
  fetchurl,
  ps,
  strace,
  texinfo,
  which,
  writableTmpDirAsHomeHook,
  writeText,
  zstd,
  version,
  # Set this to a lisp binary to use a custom bootstrap lisp compiler for SBCL.
  # Leave as null to use the default.  This is useful for local development of
  # SBCL, because you can use your existing stock SBCL as a bootstrap.  On Hydra
  # of course we can’t do that because SBCL hasn’t been built yet, so we use
  # ECL but that’s much slower.
  bootstrapLisp ? null,
}:

let
  versionMap = {
    # Necessary for Nyxt
    "2.4.6".sha256 = "sha256-pImQeELa4JoXJtYphb96VmcKrqLz7KH7cCO8pnw/MJE=";
    # Necessary for stumpwm
    "2.4.10".sha256 = "sha256-zus5a2nSkT7uBIQcKva+ylw0LOFGTD/j5FPy3hDF4vg=";
    # By unofficial and very loose convention we keep the latest version of
    # SBCL, and the previous one in case someone quickly needs to roll back.
    "2.5.7".sha256 = "sha256-xPr+t5VpnVvP+QhQkazHYtz15V+FI1Yl89eu8SyJ0dM=";
    "2.5.9".sha256 = "sha256-0bGQItQ9xJPtyXK25ZyTrmaEyWP90rQTsJZeGM1r0eI=";
  };
  # Collection of pre-built SBCL binaries for platforms that need them for
  # bootstrapping. Ideally these are to be avoided.  If ECL (or any other
  # non-binary-distributed Lisp) can run on any of these systems, that entry
  # should be removed from this list.
  bootstrapBinaries = rec {
    i686-linux = {
      version = "1.2.7";
      system = "x86-linux";
      sha256 = "07f3bz4br280qvn85i088vpzj9wcz8wmwrf665ypqx181pz2ai3j";
    };
    armv7l-linux = {
      version = "1.2.14";
      system = "armhf-linux";
      sha256 = "0sp5445rbvms6qvzhld0kwwvydw51vq5iaf4kdqsf2d9jvaz3yx5";
    };
    armv6l-linux = armv7l-linux;
    x86_64-freebsd = {
      version = "1.2.7";
      system = "x86-64-freebsd";
      sha256 = "14k42xiqd2rrim4pd5k5pjcrpkac09qnpynha8j1v4jngrvmw7y6";
    };
    x86_64-solaris = {
      version = "1.2.7";
      system = "x86-64-solaris";
      sha256 = "05c12fmac4ha72k1ckl6i780rckd7jh4g5s5hiic7fjxnf1kx8d0";
    };
  };
  sbclBootstrap = callPackage ./bootstrap.nix {
    cfg = bootstrapBinaries.${stdenv.hostPlatform.system};
  };
  bootstrapLisp' =
    if bootstrapLisp != null then
      bootstrapLisp
    else if (builtins.hasAttr stdenv.hostPlatform.system bootstrapBinaries) then
      "${sbclBootstrap}/bin/sbcl --disable-debugger --no-userinit --no-sysinit"
    else
      "${lib.getExe ecl} --norc";

in

stdenv.mkDerivation (self: {
  pname = "sbcl";
  inherit version;

  src = fetchurl {
    # Changing the version shouldn’t change the source for the
    # derivation. Override the src entirely if desired.
    url = "mirror://sourceforge/project/sbcl/sbcl/${version}/sbcl-${version}-source.tar.bz2";
    inherit (versionMap.${version}) sha256;
  };

  nativeBuildInputs = [
    texinfo
  ]
  ++ lib.optionals self.doCheck (
    [
      which
      writableTmpDirAsHomeHook
    ]
    ++ lib.optionals (builtins.elem stdenv.system strace.meta.platforms) [
      strace
    ]
    ++ lib.optionals (lib.versionOlder "2.4.10" self.version) [
      ps
    ]
  );
  buildInputs = lib.optionals self.coreCompression (
    # Declare at the point of actual use in case the caller wants to override
    # buildInputs to sidestep this.
    assert lib.assertMsg (!self.purgeNixReferences) ''
      Cannot enable coreCompression when purging Nix references, because compression requires linking in zstd
    '';
    [ zstd ]
  );

  threadSupport = (
    stdenv.hostPlatform.isx86
    || "aarch64-linux" == stdenv.hostPlatform.system
    || "aarch64-darwin" == stdenv.hostPlatform.system
  );
  # Meant for sbcl used for creating binaries portable to non-NixOS via save-lisp-and-die.
  # Note that the created binaries still need `patchelf --set-interpreter ...`
  # to get rid of ${glibc} dependency.
  purgeNixReferences = false;
  coreCompression = true;
  markRegionGC = self.threadSupport;
  disableImmobileSpace = false;
  linkableRuntime = stdenv.hostPlatform.isx86;

  # I don’t know why these are failing (on ofBorg), and I’d rather just disable
  # them and move forward with the succeeding tests than block testing
  # altogether. One by one hopefully we can fix these (on ofBorg,
  # upstream--somehow some way) in due time.
  disabledTestFiles =
    lib.optionals (lib.versionOlder "2.5.2" self.version) [ "debug.impure.lisp" ]
    ++
      lib.optionals
        (builtins.elem stdenv.hostPlatform.system [
          "x86_64-linux"
          "aarch64-linux"
        ])
        [
          "foreign-stack-alignment.impure.lisp"
          # Floating point tests are fragile
          # https://sourceforge.net/p/sbcl/mailman/message/58728554/
          "compiler.pure.lisp"
          "float.pure.lisp"
        ]
    ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
      # This is failing on aarch64-linux on ofBorg. Not on my local machine nor on
      # a VM on my laptop. Not sure what’s wrong.
      "traceroot.impure.lisp"
      # Heisentest, sometimes fails on ofBorg, would rather just disable it than
      # have it block a release.
      "futex-wait.test.sh"
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-darwin") [
      # Fail intermittently
      "gc.impure.lisp"
      "threads.pure.lisp"
    ];

  patches =
    # Support the NIX_SBCL_DYNAMIC_SPACE_SIZE envvar. Upstream SBCL didn’t want
    # to include this (see
    # "https://sourceforge.net/p/sbcl/mailman/sbcl-devel/thread/2cf20df7-01d0-44f2-8551-0df01fe55f1a%400brg.net/"),
    # but for Nix envvars are sufficiently useful that it’s worth maintaining
    # this functionality downstream.
    if lib.versionOlder "2.5.2" self.version then
      [
        ./dynamic-space-size-envvar-2.5.3-feature.patch
        ./dynamic-space-size-envvar-2.5.3-tests.patch
      ]
    else
      [
        ./dynamic-space-size-envvar-2.5.2-feature.patch
        ./dynamic-space-size-envvar-2.5.2-tests.patch
      ];

  sbclPatchPhase =
    lib.optionalString (self.disabledTestFiles != [ ]) ''
      (cd tests ; rm -f ${lib.concatStringsSep " " self.disabledTestFiles})
    ''
    + lib.optionalString self.purgeNixReferences ''
      # This is the default location to look for the core; by default in $out/lib/sbcl
      sed 's@^\(#define SBCL_HOME\) .*$@\1 "/no-such-path"@' \
          -i src/runtime/runtime.c
    ''
    + ''
      (
        shopt -s nullglob
        # Tests need patching regardless of purging of paths from the final
        # binary. There are some tricky files in nested directories which should
        # definitely NOT be patched this way, hence just a single * (and no
        # globstar).
        substituteInPlace ${if self.purgeNixReferences then "tests" else "{tests,src/code}"}/*.{lisp,sh} \
          --replace-quiet /usr/bin/env "${coreutils}/bin/env" \
          --replace-quiet /bin/uname "${coreutils}/bin/uname" \
          --replace-quiet /bin/sh "${stdenv.shell}"
      )
      # Official source release tarballs will have a version.lispexpr, but if you
      # want to override { src = ... } it might not exist. It’s required for
      # building, so create a mock version as a backup.
      if [[ ! -a version.lisp-expr ]]; then
        echo '"${self.version}.nixos"' > version.lisp-expr
      fi
    '';

  preConfigurePhases = "sbclPatchPhase";

  enableFeatures =
    assert lib.assertMsg (
      self.markRegionGC -> self.threadSupport
    ) "SBCL mark region GC requires thread support";
    lib.optional self.threadSupport "sb-thread"
    ++ lib.optional self.linkableRuntime "sb-linkable-runtime"
    ++ lib.optional self.coreCompression "sb-core-compression"
    ++ lib.optional stdenv.hostPlatform.isAarch32 "arm"
    ++ lib.optional self.markRegionGC "mark-region-gc";

  disableFeatures =
    lib.optional (!self.threadSupport) "sb-thread"
    ++ lib.optionals self.disableImmobileSpace [
      "immobile-space"
      "immobile-code"
      "compact-instance-header"
    ];

  buildArgs = [
    "--prefix=$out"
    "--xc-host=${lib.escapeShellArg bootstrapLisp'}"
  ]
  ++ map (x: "--with-${x}") self.enableFeatures
  ++ map (x: "--without-${x}") self.disableFeatures
  ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-darwin") [
    "--arch=arm64"
  ];

  # Fails to find `O_LARGEFILE` otherwise.
  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  buildPhase = ''
    runHook preBuild

    export INSTALL_ROOT=$out
    sh make.sh ${lib.concatStringsSep " " self.buildArgs}
    (cd doc/manual ; make info)

    runHook postBuild
  '';

  # Tests on ofBorg’s x86_64-darwin platforms are so unstable that a random one
  # will fail every other run. There’s a deeper problem here; we might as well
  # disable them entirely so at least the other platforms get to benefit from
  # testing.
  doCheck = stdenv.hostPlatform.system != "x86_64-darwin";

  # From the INSTALL docs
  checkPhase = ''
    runHook preCheck

    (cd tests && sh run-tests.sh)

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    sh install.sh

  ''
  + lib.optionalString (!self.purgeNixReferences) ''
    cp -r src $out/lib/sbcl
    cp -r contrib $out/lib/sbcl
    cat >$out/lib/sbcl/sbclrc <<EOF
     (setf (logical-pathname-translations "SYS")
       '(("SYS:SRC;**;*.*.*" #P"$out/lib/sbcl/src/**/*.*")
         ("SYS:CONTRIB;**;*.*.*" #P"$out/lib/sbcl/contrib/**/*.*")))
    EOF
  ''
  + ''
    runHook postInstall
  '';

  setupHook = lib.optional self.purgeNixReferences (
    writeText "setupHook.sh" ''
      addEnvHooks "$targetOffset" _setSbclHome
      _setSbclHome() {
        export SBCL_HOME='@out@/lib/sbcl/'
      }
    ''
  );

  meta = with lib; {
    description = "Common Lisp compiler";
    homepage = "https://sbcl.org";
    license = licenses.publicDomain; # and FreeBSD
    mainProgram = "sbcl";
    teams = [ lib.teams.lisp ];
    platforms = attrNames bootstrapBinaries ++ [
      # These aren’t bootstrapped using the binary distribution but compiled
      # using a separate (lisp) host
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
})
