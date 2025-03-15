{
  lib,
  fetchzip,
  buildNpmPackage,
  makeWrapper,
  nodejs,
}:
buildNpmPackage rec {
  pname = "zeus-cli";
  version = "1.6.5";

  src = fetchzip {
    url = "https://registry.npmjs.org/@zeppos/${pname}/-/${pname}-${version}.tgz";
    hash = "sha256-vPRjA6Od0ALUxhdYEAdacgVUd4OxpkiqaRZ92XzUypU=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs ];

  npmDepsHash = "sha256-ZasKVTTl2Y6VWlG4b+I+E1Asr6HA77bJcjwvK8H9KVg=";

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
    wrapProgram "$out/bin/${meta.mainProgram}" \
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
}
