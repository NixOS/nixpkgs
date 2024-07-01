{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "wrangler";
  version = "3.62.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-sdk";
    rev = "${pname}@${version}";
    hash = "sha256-Dd1ngrnQnU2QCSvbsZq51DObjgd3Fq1LkCAqe/Qsd9k=";
  };

  npmDepsHash = "sha256-RbxJYKFMPlklXjMb/iqmp/qnvV72NT4y3DIDD2UZG1U=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line interface for all things Cloudflare Workers";
    homepage = "https://github.com/cloudflare/workers-sdk#readme";
    license = "MIT OR Apache-2.0";
    maintainers = with lib.maintainers; [ dezren39 ];
    mainProgram = "wrangler";
  };
}
