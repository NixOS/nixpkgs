{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unshieldv3";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "wfr";
    repo = "unshieldv3";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ScUlKuvkq4UglEVJL8NreAGDZFLVrEpEBQCZvu7XOrg=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;
  postCheck = ''
    for i in $src/test-data/*.Z; do
      mkdir -p test
      ./unshieldv3 extract $i test
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to extract .Z files from InstallShield V3 (Z) installers";
    homepage = "https://github.com/wfr/unshieldv3";
    changelog = "https://github.com/wfr/unshieldv3/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "unshieldv3";
    maintainers = [ lib.maintainers.jchw ];
  };
})
