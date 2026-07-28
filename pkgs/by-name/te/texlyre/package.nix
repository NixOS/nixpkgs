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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "TeXlyre";
    repo = "texlyre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HTmHqTvuf8RXWnHYLZY44aWdawpvcat9GytkeKnXGFI=";
  };

  npmDepsHash = "sha256-381+vWSEMj5z/K6/av9Tsb9m6XRgffg1upNBD5uHGao=";

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
      version = "30.2.2";
      src = fetchFromGitHub {
        owner = "TeXlyre";
        repo = "drawio-embed-mirror";
        tag = "v${finalAttrs.version}";
        hash = "sha256-bdOhviJl0P/+GSJKaHMbGoPf+uEhoX5GeyY6bGBOpCg=";
      };
      dontBuild = true;
      installPhase = "cp -a . $out";
    });
    busytexAssets = stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "busytex-assets";
      version = "1.2.3";
      src = fetchFromGitHub {
        owner = "TeXlyre";
        repo = "texlyre-busytex";
        tag = "assets-v${finalAttrs.version}";
        hash = "sha256-w7IHHiFNQ2zo010/dxWzM9QV/EBNFcgv63CRHZyY7xI=";
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
