{
  lib,
  buildNpmPackage,
  makeBinaryWrapper,
  nodejs_22,
  inter,
  fira-code,
  nixosTests,
  pname,
  version,
  src,
  # This is a app can only be used in a browser and starts a web server only accessible at
  # localhost/127.0.0.1 from the local computer at the given port.
  defaultHostname ? "localhost",
  defaultFrontendPort ? 8000,
  defaultBackendOrigin ? "/api",
  defaultIsDemo ? "false",
}:
let
  nodejs = nodejs_22;
in
buildNpmPackage {
  pname = "${pname}-frontend";
  inherit version nodejs;

  src = "${src}/frontend";

  npmDepsHash = "sha256-7XlTUKVrjzZ4+lcePyBGxncU2R6Fgy817flHJKJmqfU=";

  # The following nextjs packaging is largely based on nextjs-ollama-llm-ui

  patches = [
    # nextjs tries to download google fonts from the internet during buildPhase and fails in Nix sandbox.
    # We patch the code to expect local fonts that we load from Nixpkgs in preBuild phase.
    ./localfont.patch
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  preBuild = ''
    # We have to pass and bake in the variables into the package
    echo "NEXT_PUBLIC_BACKEND_ORIGIN=${defaultBackendOrigin}" > .env
    echo "NEXT_PUBLIC_IS_DEMO=${defaultIsDemo}" >> .env

    # Replace the googleapis.com fonts with local copies from nixpkgs
    cp "${inter}/share/fonts/truetype/InterVariable.ttf" \
       "${fira-code}/share/fonts/truetype/FiraCode-VF.ttf" \
       config/
  '';

  postBuild = ''
    # Add a shebang to the server js file, then patch the shebang to use a nixpkgs nodejs binary.
    sed -i '1s|^|#!/usr/bin/env node\n|' .next/standalone/server.js
    patchShebangs .next/standalone/server.js
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share,bin}

    cp -r .next/standalone $out/share/homepage/
    cp -r public $out/share/homepage/public

    mkdir -p $out/share/homepage/.next
    cp -r .next/static $out/share/homepage/.next/static

    # https://github.com/vercel/next.js/discussions/58864
    ln -s /var/cache/unittcms $out/share/homepage/.next/cache
    # also provide a environment variable to override the cache directory
    substituteInPlace $out/share/homepage/node_modules/next/dist/server/image-optimizer.js \
        --replace '_path.join)(distDir,' '_path.join)(process.env["NEXT_CACHE_DIR"] || distDir,'

    chmod +x $out/share/homepage/server.js

    # we set a default port to support "nix run ..."
    makeWrapper $out/share/homepage/server.js $out/bin/unittcms-frontend \
      --set-default PORT "${toString defaultFrontendPort}" \
      --set-default HOSTNAME "${defaultHostname}"

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) unittcms;
    };
  };

  meta = {
    description = "Frontend of UnitTCMS, an open source test case management system designed for self-hosted use";
    homepage = "https://www.unittcms.org/";
    mainProgram = "unittcms-frontend";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ RadxaYuntian ];
  };
}
