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
  pname =
    if args ? pname then
      assert nameVersionAssertion (!args ? name && args ? version);
      args.pname
    else
      assert nameVersionAssertion (args ? name && !args ? version);
      lib.getName args.name;
  version = if args ? version then args.version else lib.getVersion args.name;
  overrides = callPackage overridesFile { };
  override = if builtins.hasAttr pname overrides then builtins.getAttr pname overrides else lib.id;
  # Will be merged into derivation attributes verbatim
  extraArgs = removeAttrs args [
    "name"
    "pname"
    "version"
    "buildInputs"
    "meta"
    "src"
  ];
  commonArgs = {
    inherit version;
    strictDeps = true;
    dontConfigure = true;
    env = {
      CSC_OPTIONS = lib.concatStringsSep " " cscOptions;
    }
    // (args.env or { });
  }
  // extraArgs;
  # Some eggs' tests expect the egg to already be installed so that its modules are available for
  # importing and programs are available in PATH. This derivation thus only builds the egg and the
  # main derivation below then pulls it in to be able to run the tests via `checkPhase`. Other than
  # that, it merely re-exports the main output of this derivation here.
  noCheckDrv =
    (stdenv.mkDerivation (
      {
        inherit src;
        pname = "chicken-${pname}-no-check";
        propagatedBuildInputs = buildInputs;
        nativeBuildInputs = [
          chicken
          makeWrapper
        ];
        buildInputs = [ chicken ];
        outputs = [
          "out"
          "build"
        ];
        buildPhase = ''
          runHook preBuild

          # From CHICKEN 6 on, chicken-install takes a lock in its egg cache even
          # when building an egg from the current directory, and the cache defaults
          # to a location under HOME, which is not writable in the sandbox. The
          # cache itself stays empty: with -cached, chicken-install builds the
          # unpacked egg in place. The install phase runs in the same shell, so it
          # inherits this.
          export CHICKEN_EGG_CACHE="$NIX_BUILD_TOP/chicken-egg-cache"
          mkdir -p "$CHICKEN_EGG_CACHE"

          chicken-install -cached -no-install -host ${lib.escapeShellArgs chickenInstallFlags}

          # Capture source + build artifcats as it's required by some tests (see main derivation below)
          cp -r . $build

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          local repo=$out/lib/chicken/${toString chicken.binaryVersion}
          CHICKEN_INSTALL_PREFIX=$out \
          CHICKEN_INSTALL_REPOSITORY=$repo \
          chicken-install -cached -host ${lib.escapeShellArgs chickenInstallFlags}

          # Patching the generated .egg-info instead of the original .egg to work
          # around https://bugs.call-cc.org/ticket/1855, which is unfixed as of
          # CHICKEN 6.0.0: eggs whose .egg carries no version property are
          # installed without one.
          csi -e "(write (cons '(version \"${version}\") (read)))" < "$repo/${pname}.egg-info" > "${pname}.egg-info.new"
          mv "${pname}.egg-info.new" "$repo/${pname}.egg-info"

          for f in $out/bin/*
          do
            wrapProgram $f \
              --prefix CHICKEN_REPOSITORY_PATH : "$repo:$CHICKEN_REPOSITORY_PATH" \
              --prefix CHICKEN_INCLUDE_PATH : "$CHICKEN_INCLUDE_PATH:$out/share" \
              --prefix PATH : "$out/bin:${chicken}/bin"
          done

          runHook postInstall
        '';
      }
      // commonArgs
    )).overrideAttrs
      override;
in
(stdenv.mkDerivation (
  {
    src = noCheckDrv.build;
    pname = "chicken-${pname}";
    buildInputs = [
      chicken
      noCheckDrv
    ];
    nativeCheckInputs = [
      chicken
      noCheckDrv
    ];
    dontPatch = true;
    dontBuild = true;
    doCheck = true;
    dontFixup = true;
    checkPhase = ''
      runHook preCheck

      if [ -e tests/run.scm ]; then
        (
          cd tests
          csi -s run.scm ${pname} "${version}"
        )
      fi

      runHook postCheck
    '';
    installPhase = ''
      ln -s ${noCheckDrv} $out
    '';
    meta = (args.meta or { }) // {
      inherit (chicken.meta) platforms;
      maintainers = lib.lists.unique ((args.meta.maintainers or [ ]) ++ chicken.meta.maintainers);
    };
  }
  // commonArgs
)).overrideAttrs
  override
