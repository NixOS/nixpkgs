{
  callPackage,
  lib,
  stdenv,
  chicken,
  makeWrapper,
}:
{
  src,
  buildInputs ? [ ],
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
  name = if args ? name then args.name else "${args.pname}-${args.version}";
  overrides = callPackage ./overrides.nix { };
  override = if builtins.hasAttr pname overrides then builtins.getAttr pname overrides else lib.id;
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

    CSC_OPTIONS = lib.concatStringsSep " " cscOptions;

    buildPhase = ''
      runHook preBuild
      chicken-install -cached -no-install -host ${lib.escapeShellArgs chickenInstallFlags}
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      export CHICKEN_INSTALL_PREFIX=$out
      export CHICKEN_INSTALL_REPOSITORY=$out/lib/chicken/${toString chicken.binaryVersion}
      chicken-install -cached -host ${lib.escapeShellArgs chickenInstallFlags}

      # Patching generated .egg-info instead of original .egg to work around https://bugs.call-cc.org/ticket/1855
      csi -e "(write (cons '(version \"${version}\") (read)))" < "$CHICKEN_INSTALL_REPOSITORY/${pname}.egg-info" > "${pname}.egg-info.new"
      mv "${pname}.egg-info.new" "$CHICKEN_INSTALL_REPOSITORY/${pname}.egg-info"

      for f in $out/bin/*
      do
        wrapProgram $f \
          --prefix CHICKEN_REPOSITORY_PATH : "$out/lib/chicken/${toString chicken.binaryVersion}:$CHICKEN_REPOSITORY_PATH" \
          --prefix CHICKEN_INCLUDE_PATH : "$CHICKEN_INCLUDE_PATH:$out/share" \
          --prefix PATH : "$out/bin:${chicken}/bin:$CHICKEN_REPOSITORY_PATH"
      done

      runHook postInstall
    '';

    dontConfigure = true;

    meta = {
      inherit (chicken.meta) platforms;
    }
    // args.meta or { };
  }
  // builtins.removeAttrs args [
    "name"
    "pname"
    "version"
    "buildInputs"
    "meta"
  ]
)).overrideAttrs
  override
