{
  lib,
  buildNpmPackage,
  makeBinaryWrapper,
  nodejs_22,
  pname,
  version,
  src,
  defaultNodeEnv ? "production",
  defaultBackendPort ? 8001,
  defaultFrontendOrigin ? "http://localhost:8000",
  defaultSecretKey ? "",
}:
let
  nodejs = nodejs_22;
in
buildNpmPackage {
  pname = "${pname}-backend";
  inherit version nodejs;

  src = "${src}/backend";

  npmDepsHash = "sha256-0ckmbzEw0UrlEisrn5Y5cygk3DM+S7r8K19bAzrZbrU=";

  postPatch = ''
    # Patch state directory to be $PWD
    for f in $(find . -name "*.js" -type f -not -path "./node_modules/*"); do
      substituteInPlace "$f" \
        --replace-quiet 'path.join(__dirname,' 'path.resolve(__dirname,' \
        --replace-quiet "path.resolve(__dirname, '../../" "path.resolve('" \
        --replace-quiet "path.resolve(__dirname, '../" "path.resolve('" \
        --replace-quiet "path.resolve(__dirname, '" "path.resolve('"
    done
  '';

  dontNpmBuild = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} $out/bin/unittcms-backend \
      --add-flags $out/lib/node_modules/unittcms-backend/index.js \
      --set-default NODE_ENV "${defaultNodeEnv}" \
      --set-default PORT ${toString defaultBackendPort} \
      --set-default FRONTEND_ORIGIN "${defaultFrontendOrigin}" \
      --set-default SECRET_KEY "${defaultSecretKey}"

    export defaultNodeEnv="${defaultNodeEnv}"
    substituteAll "${./unittcms-sequelize.sh}" "$out/bin/unittcms-sequelize"
    chmod +x "$out/bin/unittcms-sequelize"
  '';

  meta = {
    description = "Backend of UnitTCMS, an open source test case management system designed for self-hosted use";
    homepage = "https://www.unittcms.org/";
    mainProgram = "unittcms-backend";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ RadxaYuntian ];
  };
}
