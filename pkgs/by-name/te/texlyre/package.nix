{
  lib,
  xsel,
  serve,
  fetchzip,
  makeWrapper,
  buildNpmPackage,
  fetchFromGitHub,

  baseUrl ? "/",
}:

buildNpmPackage (finalAttrs: {
  pname = "texlyre";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "TeXlyre";
    repo = "texlyre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aBGhTJS/UDcWOhzP4HtIQO5ZjNGXTj3oPLje65HIhe4=";
  };

  npmDepsHash = "sha256-davqKXgSwjPM0QQ/moo5sjh7e9wVXjH30SrFC4opmuQ=";

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
    drawioEmbed = fetchzip {
      url = "https://github.com/TeXlyre/drawio-embed-mirror/archive/refs/tags/v29.7.9.zip";
      hash = "sha256-mj+i+6n14Koo9TYaygrCgFg0OLfBZnnL6rE3PkJGa9w=";
    };
    busytexAssets = fetchzip {
      url = "https://github.com/TeXlyre/texlyre-busytex/releases/download/assets-v1.1.1/busytex-assets.tar.gz";
      hash = "sha256-CLhLYLNXsJflX6o642EEJu+hxwoy3zkzfAOShiZGVPg=";
      stripRoot = false;
    };
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
