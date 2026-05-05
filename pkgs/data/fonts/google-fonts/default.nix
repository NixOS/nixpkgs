{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  symlinkJoin,

  # passthru.updateScript
  _experimental-update-script-combinators,
  gitMinimal,
  nix,
  python3Packages,
  unstableGitUpdater,
  writers,
  writeShellScript,
}:

let
  version = "0-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "7a23c80c17f403896540f1f68c02f59d8f3d3482";
    hash = "sha256-XO/z+ozo6dou/2d5g0J13BResNVag/zL0RaEbjEfvPc=";
  };

  fontsInfo = lib.importJSON ./fonts.json;

  normalizeName = name: lib.replaceString " " "-" (lib.toLower name);
  makeAttrName =
    name:
    let
      normalized = normalizeName name;
    in
    if builtins.match "^[[:digit:]].*" normalized != null then "_" + normalized else normalized;

  normalizeCategory = category: lib.replaceString "_" "-" (lib.toLower category);
  makeDescription =
    designer: category: "${lib.toSentenceCase (normalizeCategory category)} font by ${designer}";

  makeHomepage =
    name: minisite:
    if minisite != "" then
      minisite
    else
      "https://fonts.google.com/specimen/${lib.replaceString " " "+" name}";

  licenses = {
    APACHE2 = lib.licenses.asl20;
    OFL = lib.licenses.ofl;
    UFL = lib.licenses.ufl;
  };

  metaBase = {
    downloadPage = "https://github.com/google/fonts";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = [ lib.maintainers.thunze ];
    platforms = lib.platforms.all;
  };

  makeFontPackage =
    {
      name,
      designer,
      minisite,
      category,
      license,
      path,
      ...
    }:
    stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "google-fonts-${normalizeName name}";
      inherit version src;

      strictDeps = true;
      __structuredAttrs = true;

      # Setting `sourceRoot` instead would still copy the entire source to the
      # build directory, which can be slow due to its size.
      unpackCmd = ''
        cp -r "$src/${path}" .
      '';

      nativeBuildInputs = [ installFonts ];

      dontInstallFonts = true;
      doInstallCheck = true;

      installPhase = ''
        runHook preInstall

        installFont ttf $out/share/fonts/truetype/google-fonts/${normalizeName name}

        runHook postInstall
      '';

      # Check that fonts are present after installation
      installCheckPhase = ''
        runHook preInstallCheck

        ls -A $out/share/fonts/truetype/google-fonts/${normalizeName name}/*.ttf

        runHook postInstallCheck
      '';

      meta = metaBase // {
        description = makeDescription designer category;
        homepage = makeHomepage name minisite;
        license = licenses.${license};
      };
    });

  fontPackages = lib.pipe fontsInfo [
    (map (font: lib.nameValuePair (makeAttrName font.name) (makeFontPackage font)))
    builtins.listToAttrs
  ];
in

{
  google-fonts = lib.recurseIntoAttrs fontPackages;

  google-fonts-full = symlinkJoin {
    pname = "google-fonts-full";
    inherit version;

    strictDeps = true;
    __structuredAttrs = true;

    # All font packages except Adobe Blank because there have been reports
    # that Adobe Blank causes issues with fontconfig
    paths = builtins.attrValues (
      lib.filterAttrs (attrName: drv: attrName != "adobe-blank") fontPackages
    );

    passthru = {
      inherit src;

      updateScript = _experimental-update-script-combinators.sequence [
        # Update the version, commit hash, and source hash
        # Silence output to let the collect script determine the commit metadata
        {
          command = writeShellScript "google-fonts-update-script" ''
            ${lib.head (unstableGitUpdater { })} --hardcode-zero-version --shallow-clone > /dev/null
          '';
          supportedFeatures = [ "silent" ];
        }
        # Collect metadata about the available fonts and write it to `fonts.json`
        {
          command = writers.writePython3 "google-fonts-collect-script" {
            libraries = with python3Packages; [
              gftools
              protobuf
            ];
            makeWrapperArgs = [
              "--prefix"
              "PATH"
              ":"
              (lib.makeBinPath [
                gitMinimal
                nix
              ])
              "--set"
              "PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION"
              "python"
            ];
            doCheck = true;
          } ./collect.py;
          supportedFeatures = [ "commit" ];
        }
      ];
    };

    meta = metaBase // {
      description = "Full collection of fonts provided by Google Fonts";
      homepage = "https://fonts.google.com/";
      license = lib.licenses.AND (builtins.attrValues licenses);
    };
  };
}
