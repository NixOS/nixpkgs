{
  callPackage,
  lib,
  stdenv,
  chicken,
  makeWrapper,

  # Release-specific arguments, supplied by the per-release directory.
  overridesFile,
}:
{
  src,
  buildInputs ? [ ],
  checkInputs ? [ ],
  chickenInstallFlags ? [ ],
  cscOptions ? [ ],
  ...
}@args:

let
  nameVersionAssertion =
    pred: lib.assertMsg pred "either name or both pname and version must be given";
  eggName =
    if args ? pname then
      assert nameVersionAssertion (!args ? name && args ? version);
      args.pname
    else
      assert nameVersionAssertion (args ? name && !args ? version);
      lib.getName args.name;
  version = if args ? version then args.version else lib.getVersion args.name;
  overrides = callPackage overridesFile { };
  override =
    if builtins.hasAttr eggName overrides then builtins.getAttr eggName overrides else lib.id;
in
(stdenv.mkDerivation (
  finalAttrs:
  let
    # Some eggs' tests expect the egg to be installed already so that their modules can be imported
    # and their programs found in PATH. The `doCheck = false` override below builds and installs the
    # egg without running its tests, and the checked derivation takes it as an input. We avoid
    # running the build twice by disabling the build in the main derivation and capturing the
    # no-check derivation's build artifacts in a separate output. The main derivation then restores
    # the build artifacts from that output in `checkPhase`.
    noCheckDrv = finalAttrs.finalPackage.overrideAttrs { doCheck = false; };
    # From CHICKEN 6 on, chicken-install takes a lock in its egg cache even
    # when building an egg from the current directory, and the cache defaults
    # to a location under HOME, which is not writable in the sandbox. The
    # cache itself stays empty: with -cached, chicken-install builds the
    # unpacked egg in place. The install phase runs in the same shell, so it
    # inherits this. This snippet is included in all phases which need to run
    # chicken-install.
    setupCache = ''
      export CHICKEN_EGG_CACHE="$NIX_BUILD_TOP/chicken-egg-cache"
      mkdir -p "$CHICKEN_EGG_CACHE"
    '';
  in
  {
    pname = "chicken-${lib.versions.major chicken.version}-${eggName}${
      lib.optionalString (!finalAttrs.doCheck) "-no-check"
    }";
    inherit version;
    propagatedBuildInputs = buildInputs;
    nativeBuildInputs = [
      chicken
      makeWrapper
    ];
    buildInputs = [
      chicken
    ]
    ++ lib.optionals finalAttrs.doCheck [
      noCheckDrv
    ];
    nativeCheckInputs = [
      chicken
    ]
    ++ lib.optionals finalAttrs.doCheck [
      noCheckDrv
    ];

    strictDeps = true;

    env = {
      CSC_OPTIONS = lib.concatStringsSep " " cscOptions;
    }
    // (args.env or { });

    outputs = [
      "out"
    ]
    ++ lib.optional (!finalAttrs.doCheck) "build";

    dontUnpack = finalAttrs.doCheck;
    dontPatch = finalAttrs.doCheck;
    # Disable build when doCheck is true and re-use the build artifacts of the no-check variant via the "build" output.
    # This way, we only need to build the egg once across the no-check and check variants.
    dontBuild = finalAttrs.doCheck;

    buildPhase = ''
      runHook preBuild

      ${setupCache}

      chicken-install -cached -no-install -host ${lib.escapeShellArgs chickenInstallFlags}

      # Capture sources and build artifacts so we can re-use them in checkPhase
      cp -r . $build

      runHook postBuild
    '';

    doCheck = true;

    checkPhase = lib.optionalString finalAttrs.doCheck ''
      runHook preCheck

      # Restore build output since buildPhase is disabled when we arrive here
      cp -r ${noCheckDrv.build}/. .
      chmod -R +w .

      if [ -e tests/run.scm ]; then
        (
          cd tests
          csi -s run.scm ${eggName} "${version}"
        )
      fi

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      ${setupCache}

      export CHICKEN_INSTALL_PREFIX=$out
      export CHICKEN_INSTALL_REPOSITORY=$out/lib/chicken/${toString chicken.binaryVersion}
      chicken-install -cached -host ${lib.escapeShellArgs chickenInstallFlags}

      # Patching the generated .egg-info instead of the original .egg to work
      # around https://bugs.call-cc.org/ticket/1855, which is unfixed as of
      # CHICKEN 6.0.0: eggs whose .egg carries no version property are
      # installed without one.
      csi -e "(write (cons '(version \"${version}\") (read)))" < "$CHICKEN_INSTALL_REPOSITORY/${eggName}.egg-info" > "${eggName}.egg-info.new"
      mv "${eggName}.egg-info.new" "$CHICKEN_INSTALL_REPOSITORY/${eggName}.egg-info"

      for f in $out/bin/*
      do
        wrapProgram $f \
          --prefix CHICKEN_REPOSITORY_PATH : "$out/lib/chicken/${toString chicken.binaryVersion}:$CHICKEN_REPOSITORY_PATH" \
          --prefix CHICKEN_INCLUDE_PATH : "$CHICKEN_INCLUDE_PATH:$out/share" \
          --prefix PATH : "$out/bin:${chicken}/bin"
      done

      runHook postInstall
    '';

    dontConfigure = true;

    meta = (args.meta or { }) // {
      inherit (chicken.meta) platforms;
      maintainers = lib.lists.unique ((args.meta.maintainers or [ ]) ++ chicken.meta.maintainers);
    };
  }
  // removeAttrs args [
    "name"
    "pname"
    "version"
    "buildInputs"
    "meta"
  ]
)).overrideAttrs
  override
