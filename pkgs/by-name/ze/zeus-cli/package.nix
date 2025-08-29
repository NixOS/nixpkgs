{
  lib,
  fetchzip,
  buildNpmPackage,
  makeWrapper,
  nodejs,
}:
buildNpmPackage (finalAttrs: {
  pname = "zeus-cli";
  version = "1.6.7";

  src = fetchzip {
    url = "https://registry.npmjs.org/@zeppos/zeus-cli/-/zeus-cli-${finalAttrs.version}.tgz";
    hash = "sha256-86AoW0DTIztfMTVdI2x7KVyt3yUuniIaFdGQ6iLtRdQ=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs ];

  npmDepsHash = "sha256-zTb6A5UTgV/RcuynRi8uHF/vwLKkI1Hbo1KO1kjIntE=";

  patches = [
    ./fix_script_name.patch
    ./fix_writable.patch
  ];

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  postInstall = ''
    # Add npm to PATH (needed to create and compile apps)
    wrapProgram "$out/bin/zeus" \
      --suffix PATH : ${lib.makeBinPath [ nodejs ]}
  '';

  meta = {
    description = "Standard tooling for Zepp App development";
    homepage = "https://docs.zepp.com/docs/guides/tools/cli/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ griffi-gh ];
    mainProgram = "zeus";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
