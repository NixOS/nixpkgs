{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  gnat,
  which,
  xmlada, # for src
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gprbuild-boot";
  version = "26.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "gprbuild";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j9UQw275cfCkYdmDyc4g2LuFSrqXmWGV66AaykctKSA=";
  };

  nativeBuildInputs = [
    gnat
    which
  ];

  patches =
    lib.optionals (lib.versionOlder gnat.version "15") [
      # gpr-compilation-protocol.adb:982:27: error: "To_Unix_Time_64" not declared in "Conversions"
      (fetchpatch2 {
        url = "https://github.com/AdaCore/gprbuild/commit/5c89819c8d84ca4a75663d3720185f5ed2d8fae6.patch?full_index=1";
        hash = "sha256-sZ+XfU9DDzRBVY/QYDWZS1xuR9BF2pa+QvoHHi5/IY4=";
      })
    ]
    ++ lib.optionals (lib.versionAtLeast gnat.version "16") [
      # gpr-compilation-process.adb:44:29: error: operator for type "String" is not declared in "Env_Maps"
      (fetchpatch2 {
        url = "https://github.com/AdaCore/gprbuild/commit/6421e350274b3018a26bd058b1c90d033b053f71.patch?full_index=1";
        hash = "sha256-u9bmr8abmthlyHoeqW5nS2CnaxXmbx6WVwhemxVtw+0=";
      })
    ];

  postPatch = ''
    # The Makefile uses gprbuild to build gprbuild which
    # we can't do at this point, delete it to prevent the
    # default phases from failing.
    rm Makefile

    # make sure bootstrap script runs
    patchShebangs --build bootstrap.sh
  '';

  # This setupHook populates GPR_PROJECT_PATH which is used by
  # gprbuild to find dependencies. It works quite similar to
  # the pkg-config setupHook in the sense that it also splits
  # dependencies into GPR_PROJECT_PATH and GPR_PROJECT_PATH_FOR_BUILD,
  # but gprbuild itself doesn't support this, so we'll need to
  # introducing a wrapper for it in the future remains TODO.
  # For the moment this doesn't matter since we have no situation
  # were gprbuild is used to build something used at build time.
  setupHooks = [
    ./gpr-project-path-hook.sh
  ]
  ++ lib.optionals stdenv.targetPlatform.isDarwin [
    # This setupHook replaces the paths of shared libraries starting
    # with @rpath with the absolute paths on Darwin, so that the
    # binaries can be run without additional setup.
    ./gpr-project-darwin-rpath-hook.sh
  ];

  installPhase = ''
    runHook preInstall

    ./bootstrap.sh \
      --with-xmlada=${xmlada.src} \
      --with-kb=${finalAttrs.finalPackage.passthru.gprconfig_kb} \
      --prefix=$out

    # Install custom compiler description which can detect nixpkgs'
    # GNAT wrapper as a proper Ada compiler. The default compiler
    # description expects the runtime library to be installed in
    # the same prefix which isn't the case for nixpkgs. As a
    # result, it would detect the unwrapped GNAT as a proper
    # compiler which is unable to produce working binaries.
    #
    # Our compiler description is very similar to the upstream
    # GNAT description except that we use a symlink in $out/nix-support
    # created by the cc-wrapper to find the associated runtime
    # libraries and use gnatmake instead of gnatls to find GNAT's
    # bin directory.
    install -m644 ${./nixpkgs-gnat.xml} $out/share/gprconfig/nixpkgs-gnat.xml

    runHook postInstall
  '';

  passthru = {
    gprconfig_kb = fetchFromGitHub {
      owner = "AdaCore";
      repo = "gprconfig_kb";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Ugzn03z93ZoRRkgq3XSeIsvCb2IKh2WWj7TWzqTos70=";
    };
  };

  meta = {
    description = "Multi-language extensible build tool";
    homepage = "https://github.com/AdaCore/gprbuild";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      sternenseemann
      sempiternal-aurora
    ];
    platforms = lib.platforms.all;
  };
})
