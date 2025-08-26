{
  lib,
  stdenv,
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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "jannis-baum";
    repo = "Vivify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2lxf21T9y4GMFlk0+qbaJJ/twRffYEBoBXZXe/NRDQk=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-mOgfwetiLMTDquw3f3+U1iEhBbvf0OC5lkNJHdrRSK0=";
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

    make linux

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
