{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "wrangler";
  version = lib.removePrefix "wrangler@" src.rev;

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-sdk";
    rev = "wrangler@3.15.0";
    hash = "sha256-T8PMu8UY0VFahodSGp+skjWtfdEPB0bhfCiRFdjy+B8=";
  };

  npmDepsHash = "sha256-2moi8hxLL+0hJXKM//Hqn5Dr0VXR+AP9aFlz8QfV+Z0=";

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json

    # Complains that we can't have npm and pnpm at the same time.
    rm pnpm-lock.yaml pnpm-workspace.yaml
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line interface for all things Cloudflare Workers";
    homepage = "https://developers.cloudflare.com/workers/wrangler";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ kranzes ];
    mainProgram = "wrangler";
  };
}
