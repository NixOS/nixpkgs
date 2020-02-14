{ stdenv, chicken, makeWrapper }:
{ name, src
, buildInputs ? []
, chickenInstallFlags ? []
, cscOptions          ? []
, ...} @ args:

let
  overrides = import ./overrides.nix;
  baseName = stdenv.lib.getName name;
  override = if builtins.hasAttr baseName overrides
   then
     builtins.getAttr baseName overrides
   else
     {};
in
stdenv.mkDerivation ({
  name = "chicken-${name}";
  propagatedBuildInputs = buildInputs;
  buildInputs = [ makeWrapper chicken ];

  CSC_OPTIONS = stdenv.lib.concatStringsSep " " cscOptions;

  installPhase = ''
    runHook preInstall

    export CHICKEN_INSTALL_PREFIX=$out
    export CHICKEN_INSTALL_REPOSITORY=$out/lib/chicken/${toString chicken.binaryVersion}
    chicken-install ${stdenv.lib.concatStringsSep " " chickenInstallFlags}

    for f in $out/bin/*
    do
      wrapProgram $f \
        --prefix CHICKEN_REPOSITORY_PATH : "$out/lib/chicken/${toString chicken.binaryVersion}/:$CHICKEN_REPOSITORY_PATH" \
        --prefix CHICKEN_INCLUDE_PATH : "$CHICKEN_INCLUDE_PATH:$out/share/" \
        --prefix PATH : "$out/bin:${chicken}/bin:$CHICKEN_REPOSITORY_PATH"
    done

    runHook postInstall
  '';
} // (builtins.removeAttrs args ["name" "buildInputs"]) // override)
