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
<<<<<<< HEAD
  nativeBuildInputs = [ chicken makeWrapper ];
  buildInputs = [ chicken ];

  strictDeps = true;

  CSC_OPTIONS = lib.concatStringsSep " " cscOptions;

  buildPhase = ''
    runHook preBuild
    chicken-install -cached -no-install -host ${lib.escapeShellArgs chickenInstallFlags}
    runHook postBuild
  '';

=======
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ chicken ];

  CSC_OPTIONS = lib.concatStringsSep " " cscOptions;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  installPhase = ''
    runHook preInstall

    export CHICKEN_INSTALL_PREFIX=$out
    export CHICKEN_INSTALL_REPOSITORY=$out/lib/chicken/${toString chicken.binaryVersion}
<<<<<<< HEAD
    chicken-install -cached -host ${lib.escapeShellArgs chickenInstallFlags}
=======
    chicken-install -cached ${lib.concatStringsSep " " chickenInstallFlags}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    for f in $out/bin/*
    do
      wrapProgram $f \
<<<<<<< HEAD
        --prefix CHICKEN_REPOSITORY_PATH : "$out/lib/chicken/${toString chicken.binaryVersion}:$CHICKEN_REPOSITORY_PATH" \
        --prefix CHICKEN_INCLUDE_PATH : "$CHICKEN_INCLUDE_PATH:$out/share" \
=======
        --prefix CHICKEN_REPOSITORY_PATH : "$out/lib/chicken/${toString chicken.binaryVersion}" \
        --suffix CHICKEN_INCLUDE_PATH : "$out/share" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        --prefix PATH : "$out/bin:${chicken}/bin:$CHICKEN_REPOSITORY_PATH"
    done

    runHook postInstall
  '';

<<<<<<< HEAD
=======
  dontBuild = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  dontConfigure = true;

  meta = {
    inherit (chicken.meta) platforms;
  } // args.meta or {};
} // builtins.removeAttrs args ["name" "buildInputs" "meta"]) ).overrideAttrs override
