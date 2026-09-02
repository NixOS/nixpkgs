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
  installationHelper = ''
    install_egg() {
      local dest=$1
      local repo=$dest/lib/chicken/${toString chicken.binaryVersion}
      CHICKEN_INSTALL_PREFIX=$dest \
      CHICKEN_INSTALL_REPOSITORY=$repo \
      chicken-install -cached -host ${lib.escapeShellArgs chickenInstallFlags}

      # Patching the generated .egg-info instead of the original .egg to work
      # around https://bugs.call-cc.org/ticket/1855, which is unfixed as of
      # CHICKEN 6.0.0: eggs whose .egg carries no version property are
      # installed without one.
      csi -e "(write (cons '(version \"${version}\") (read)))" < "$repo/${pname}.egg-info" > "${pname}.egg-info.new"
      mv "${pname}.egg-info.new" "$repo/${pname}.egg-info"

      for f in $dest/bin/*
      do
        wrapProgram $f \
          --prefix CHICKEN_REPOSITORY_PATH : "$repo:$CHICKEN_REPOSITORY_PATH" \
          --prefix CHICKEN_INCLUDE_PATH : "$CHICKEN_INCLUDE_PATH:$dest/share" \
          --prefix PATH : "$dest/bin:${chicken}/bin"
      done
    }
  '';
in
(stdenv.mkDerivation (
  {
    pname = "chicken-${pname}";
    inherit version;
    propagatedBuildInputs = buildInputs;
    nativeBuildInputs = [
      chicken
      makeWrapper
    ];
    buildInputs = [ chicken ];

    strictDeps = true;

    env = {
      CSC_OPTIONS = lib.concatStringsSep " " cscOptions;
    }
    // (args.env or { });

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

      runHook postBuild
    '';

    doCheck = true;

    checkPhase = ''
      runHook preCheck

      ${installationHelper}

      # Install to a temporary location so that tests can load extensions or run programs as if it
      # was already properly installed.
      tmpout=$(mktemp -d)

      # Symlink `chicken-install` so that `install_egg` will wrap it with the temporary install
      # location (just like other programs installed by the egg). This will allow us to run tests
      # via the `-test` option as if the egg was installed properly (see below).
      mkdir $tmpout/bin
      ln -s ${chicken}/bin/chicken-install $tmpout/bin/chicken-install

      install_egg $tmpout

      # Run tests via the wrapped `chicken-install` (see above)
      $tmpout/bin/chicken-install -cached -host -no-install ${lib.escapeShellArgs chickenInstallFlags} -test

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      ${installationHelper}

      install_egg $out

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
