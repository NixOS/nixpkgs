{
  lib,
  xsel,
  serve,
  fetchzip,
  stdenvNoCC,
  makeWrapper,
  buildNpmPackage,
  fetchFromGitHub,

  baseUrl ? "/",
}:

buildNpmPackage (finalAttrs: {
  pname = "texlyre";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "TeXlyre";
    repo = "texlyre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oYt+DG8lTAOY8MEZsJw2nkg7LGE/hEY7nw5UT9EQfZU=";
  };

  npmDepsHash = "sha256-MlxMej9huxgC73FUG8iifkxUnJHFWS9y50NaZ4C+aBE=";

  postPatch = ''
    sed -i 's/"version": ".*"/"version": "${finalAttrs.version}"/' package.json

    substituteInPlace texlyre.config.ts \
      --replace-fail "baseUrl: '/texlyre/'" "baseUrl: '${baseUrl}'"

    # disable downloading assets
    substituteInPlace scripts/setup-assets.cjs \
      --replace-fail "await downloadCoreAssets();" ""
  '';

  nativeBuildInputs = [ makeWrapper ];

  __structuredAttrs = true;

  preBuild = ''
    # put core assets in place
    mkdir -p public/core
    cp -r ${finalAttrs.passthru.drawioEmbed}/drawio-embed public/core/drawio-embed
    cp -r ${finalAttrs.passthru.busytexAssets} public/core/busytex

    npm run generate:configs
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    npm run test:check
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mv dist $out
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe serve} $out/bin/texlyre \
      --prefix PATH : ${lib.makeBinPath [ xsel ]} \
      --chdir $out
  '';

  passthru = {
    updateScript = ./update.sh;
    drawioEmbed = stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "drawio-embed";
      version = "31.6.1";
      src = fetchFromGitHub {
        owner = "TeXlyre";
        repo = "drawio-embed-mirror";
        tag = "v${finalAttrs.version}";
        hash = "sha256-lcttcu7N61ZoKGQgUPn7l7yRF8MXmO0tD9uzJ1V9Z94=";
      };
      dontBuild = true;
      installPhase = "cp -a . $out";
    });
    busytexAssets = stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "busytex-assets";
      version = "1.4.0";
      src = fetchFromGitHub {
        owner = "TeXlyre";
        repo = "texlyre-busytex";
        tag = "assets-v${finalAttrs.version}";
        hash = "sha256-TRpfACtq11t1tJ9waavroujgnPLHyNp3i+F4DBYCwuY=";
      };
      dontBuild = true;
      installPhase = "cp -a . $out";
    });
  };

  meta = {
    changelog = "https://github.com/TeXlyre/texlyre/releases/tag/${finalAttrs.src.rev}";
    description = "Local-first LaTeX & Typst web editor with real-time collaboration & offline support";
    homepage = "https://github.com/TeXlyre/texlyre";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    mainProgram = "texlyre";
    teams = with lib.teams; [ ngi ];
  };
})
