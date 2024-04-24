{ lib
, mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
}:

mkYarnPackage rec {
  pname = "vim-language-server";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "iamcco";
    repo = "vim-language-server";
    rev = "v${version}";
    hash = "sha256-NfBKNCTvCMIJrSiTlCG+LtVoMBMdCc3rzpDb9Vp2CGM=";
  };

  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-mo8urQaWIHu33+r0Y7mL9mJ/aSe/5CihuIetTeDHEUQ=";
  };

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    # https://stackoverflow.com/a/69699772/4935114
    env NODE_OPTIONS=--openssl-legacy-provider yarn --offline build

    runHook postBuild
  '';

  doDist = false;

  meta = with lib; {
    description = "VImScript language server, LSP for vim script";
    homepage = "https://github.com/iamcco/vim-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "vim-language-server";
  };
}
