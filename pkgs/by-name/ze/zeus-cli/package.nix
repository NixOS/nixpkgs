{
  lib,
  fetchzip,
  buildNpmPackage,
  makeWrapper,
  nodejs,
}:
buildNpmPackage rec {
  pname = "zeus-cli";
  version = "1.6.6";

  src = fetchzip {
    url = "https://registry.npmjs.org/@zeppos/zeus-cli/-/zeus-cli-${version}.tgz";
    hash = "sha256-+S3vtn6R3sWw+AOMZsYpTjzBtf3se7WIlNIngDbr4b4=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs ];

  npmDepsHash = "sha256-s1blLke85tjFMJQNLP/Gsb9pREGWuFBKbjJuRDQ1srY=";

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
