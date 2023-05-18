{ callPackage, lib, stdenv, chicken, makeWrapper }:
{ name, src
, buildInputs ? []
, chickenInstallFlags ? []
, cscOptions          ? []
, ...} @ args:

let
  overrides = callPackage ./overrides.nix { };
  baseName = lib.getName name;
  override = if builtins.hasAttr baseName overrides
   then
     builtins.getAttr baseName overrides
   else
     lib.id;
in
(stdenv.mkDerivation ({
  name = "chicken-${name}";
  propagatedBuildInputs = buildInputs;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ chicken ];

  CSC_OPTIONS = lib.concatStringsSep " " cscOptions;

  installPhase = ''
    runHook preInstall

    export CHICKEN_INSTALL_PREFIX=$out
    export CHICKEN_INSTALL_REPOSITORY=$out/lib/chicken/${toString chicken.binaryVersion}
    chicken-install -cached ${lib.concatStringsSep " " chickenInstallFlags}

    for f in $out/bin/*
    do
      wrapProgram $f \
        --prefix CHICKEN_REPOSITORY_PATH : "$out/lib/chicken/${toString chicken.binaryVersion}" \
        --suffix CHICKEN_INCLUDE_PATH : "$out/share" \
        --prefix PATH : "$out/bin:${chicken}/bin:$CHICKEN_REPOSITORY_PATH"
    done

    runHook postInstall
  '';

  dontBuild = true;
  dontConfigure = true;

  meta = {
    inherit (chicken.meta) platforms;
  } // args.meta or {};
} // builtins.removeAttrs args ["name" "buildInputs" "meta"]) ).overrideAttrs override
