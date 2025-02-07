{
  callPackage,
  lib,
  stdenv,
  chicken,
  makeWrapper,
}:
{
  name,
  src,
  buildInputs ? [ ],
  chickenInstallFlags ? [ ],
  cscOptions ? [ ],
  ...
}@args:

let
  overrides = callPackage ./overrides.nix { };
  baseName = lib.getName name;
  override =
    if builtins.hasAttr baseName overrides then builtins.getAttr baseName overrides else lib.id;
in
(stdenv.mkDerivation (
  {
    name = "chicken-${name}";
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
    } // args.meta or { };
  }
  // builtins.removeAttrs args [
    "name"
    "buildInputs"
    "meta"
  ]
)).overrideAttrs
  override
