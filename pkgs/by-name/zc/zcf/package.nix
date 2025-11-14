{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  makeWrapper,
}:

buildNpmPackage {
  pname = "zcf";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "UfoMiao";
    repo = "zcf";
    rev = "b506e3b816a05a7d847748a8c480ad59cf6f2c17";
    hash = "sha256-qxqMPiGZpFOGpA5+BooOek7AuD27OG3Qc6KeZAuMjK8=";
  };

  npmDepsHash = "sha256-1vGgkR+0BlCn+nh466O6SgHRme0roIB2s3F9jebiA/g=";

  # Replace package.json with one that doesn't use catalog dependencies
  postPatch = ''
    cp ${./package.json} package.json
    cp ${./package-lock.json} package-lock.json
  '';

  # The build script uses unbuild, which compiles TypeScript
  npmBuildScript = "build";

  # Enable offline mode to prevent network access during build
  npmConfigOffline = true;

  # Disable npm's network features
  npmConfigAudit = false;
  npmConfigFund = false;

  # Required for some native Node.js modules and wrapping
  nativeBuildInputs = [
    nodejs.pkgs.node-pre-gyp
    makeWrapper
  ];

  # The project builds to the 'dist' directory
  installPhase = ''
    runHook preInstall

    # Create the standard Node.js package structure
    mkdir -p $out/lib/node_modules/zcf
    mkdir -p $out/bin

    # Copy all necessary files including node_modules
    cp -r dist bin templates package.json node_modules $out/lib/node_modules/zcf/

    # Create a wrapper script that sets NODE_PATH properly
    makeWrapper ${nodejs}/bin/node $out/bin/zcf \
      --add-flags "$out/lib/node_modules/zcf/bin/zcf.mjs" \
      --set NODE_PATH "$out/lib/node_modules/zcf/node_modules"

    runHook postInstall
  '';

  # Fix up shebangs and permissions
  postFixup = ''
    chmod +x $out/lib/node_modules/zcf/bin/zcf.mjs
    patchShebangs $out/lib/node_modules/zcf/bin/zcf.mjs
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
}
