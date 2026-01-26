{
  lib,
  stdenv,
  nix-update-script,
  fetchYarnDeps,
  fetchFromGitHub,
  yarnConfigHook,
  npmHooks,
  nodejs,
  zip,
  file,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vivify";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "jannis-baum";
    repo = "Vivify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h36kI8Pglo6Mvngg1whjMVjI0bv0v0+yPJCZTZ0BpUA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-RPi1yS1eKSwe/w0gzLhr0BGL00tHzpWAnaN3BEs7IWc=";
  };

  installPhase = ''
    runHook preInstall

    yarn install

    substituteInPlace node_modules/.bin/tsc \
      --replace-fail '/usr/bin/env node' '${lib.getExe nodejs}'

    substituteInPlace node_modules/.bin/webpack \
      --replace-fail '/usr/bin/env node' '${lib.getExe nodejs}'

    substituteInPlace node_modules/.bin/postject \
      --replace-fail '/usr/bin/env node' '${lib.getExe nodejs}'

    make VIV_VERSION=${finalAttrs.version} linux

    mkdir -p $out/bin
    install -Dm755 ./build/linux/viv $out/bin/viv
    install -Dm755 ./build/linux/vivify-server $out/bin/vivify-server

    wrapProgram $out/bin/viv \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
          file
        ]
      }
  '';

  nativeBuildInputs = [
    yarnConfigHook
    npmHooks.npmInstallHook
    zip

    nodejs
    file
  ];

  # Stripping 'unneeded symbols' causes vivify-server executable to break
  # (segmentation fault)
  dontStrip = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Live Markdown viewer";
    longDescription = ''
      Vivify brings your files to life in the browser!
      Vivify is primarily made to render Markdown and Jupyter Notebooks, but will also
      serve as a directory browser and let you view code files with syntax highlighting.
    '';
    homepage = "https://github.com/jannis-baum/Vivify";
    changelog = "https://github.com/jannis-baum/Vivify/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ skohtv ];
    platforms = lib.platforms.linux;
    mainProgram = "viv";
  };
})
