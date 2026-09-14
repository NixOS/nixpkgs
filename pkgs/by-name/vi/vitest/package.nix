{
  lib,
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage (finalAttrs: {
  pname = "vitest";
  version = "4.1.10";

  __structuredAttrs = true;

  # vitest is a pnpm monorepo, so we build from the published npm tarball
  # instead of the GitHub source.
  src = fetchurl {
    url = "https://registry.npmjs.org/vitest/-/vitest-${finalAttrs.version}.tgz";
    hash = "sha256-C5maPhTkvAlgJuph8SKarOXy2yuYlSRVNb0fjP74EA4=";
  };

  # The npm tarball ships without a lock file.
  # NOTE: Generating lock-file
  # npm install --package-lock-only --ignore-scripts
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-v85qRy42VmfWBaXkvXwyTh6iH0VM1/+RIWgUOwCWmGM=";

  dontNpmBuild = true;
  npmFlags = [ "--ignore-scripts" ];

  meta = {
    description = "Next generation testing framework powered by Vite";
    homepage = "https://github.com/vitest-dev/vitest";
    license = lib.licenses.mit;
    mainProgram = "vitest";
    maintainers = with lib.maintainers; [ tembleking ];
  };
})
