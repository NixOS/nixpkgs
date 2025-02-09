{
  lib,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm_9,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "zashboard";
  version = "1.62.1";

  src = fetchFromGitHub {
    owner = "Zephyruso";
    repo = "zashboard";
    tag = "v${version}";
    hash = "sha256-RwbfJ6sZgRD21nMRAX/eKIN7n8oqA8wRYQUq9kLZB+w=";
  };

  nativeBuildInputs = [
    pnpm_9.configHook
    nodejs
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-cY0x2VxPozKNFaoteKjfrINStkev8IO0BC9y/EMRVa0=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dashboard Using Clash API";
    homepage = "https://github.com/Zephyruso/zashboard";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
