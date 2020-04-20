{ stdenv, chicken, makeWrapper }:
{ name, src
, buildInputs ? []
, chickenInstallFlags ? []
, cscOptions          ? []
, ...} @ args:

let
  libPath = "${chicken}/var/lib/chicken/${toString chicken.binaryVersion}/";
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

  CHICKEN_REPOSITORY = libPath;
  CHICKEN_INSTALL_PREFIX = "$out";

  installPhase = ''
    runHook preInstall

    chicken-install -p $out ${stdenv.lib.concatStringsSep " " chickenInstallFlags}

    for f in $out/bin/*
    do
      wrapProgram $f \
        --set CHICKEN_REPOSITORY $CHICKEN_REPOSITORY \
        --prefix CHICKEN_REPOSITORY_EXTRA : "$out/lib/chicken/${toString chicken.binaryVersion}/:$CHICKEN_REPOSITORY_EXTRA" \
        --prefix CHICKEN_INCLUDE_PATH \; "$CHICKEN_INCLUDE_PATH;$out/share/" \
        --prefix PATH : "$out/bin:${chicken}/bin:$CHICKEN_REPOSITORY_EXTRA:$CHICKEN_REPOSITORY"
    done

    runHook postInstall
  '';
} // (builtins.removeAttrs args ["name" "buildInputs"]) // override)
