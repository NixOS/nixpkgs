{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zcf";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "UfoMiao";
    repo = "zcf";
    rev = "9093db33ed363f6f74c7418cf5907ff721278bc3";
    hash = "sha256-wOiMPkf9FRGZvp8qBh4SVSvQANA0Ome+0t9KNxjfkDM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-Zxyi4QcXT63++AXdmWfRO897ErbemZVDPCK3L9COuzk=";
  };

  # Build phase - use unbuild to compile TypeScript
  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  # Install phase
  installPhase = ''
    runHook preInstall

    # Create the standard Node.js package structure
    mkdir -p $out/lib/node_modules/zcf
    mkdir -p $out/bin

    # Copy all necessary files
    cp -r dist bin templates package.json $out/lib/node_modules/zcf/

    # Copy node_modules but exclude broken symlinks
    cp -r node_modules $out/lib/node_modules/zcf/

    # Remove broken symlink to docs directory
    rm -f $out/lib/node_modules/zcf/node_modules/.pnpm/node_modules/@zcf/docs

    # Create symlink for the binary
    ln -s $out/lib/node_modules/zcf/bin/zcf.mjs $out/bin/zcf

    runHook postInstall
  '';

  # Fix up shebangs and permissions
  postFixup = ''
    chmod +x $out/lib/node_modules/zcf/bin/zcf.mjs $out/bin/zcf
    patchShebangs $out/lib/node_modules/zcf/bin/zcf.mjs $out/bin/zcf
  '';

  # Meta information
  meta = {
    description = "Zero-Config Code Flow - One-click configuration tool for Code Cli";
    homepage = "https://github.com/UfoMiao/zcf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luochen1990 ];
    mainProgram = "zcf";
    platforms = lib.platforms.all;
  };
})
