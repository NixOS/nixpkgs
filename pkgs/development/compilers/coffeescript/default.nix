{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "coffeescript";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "jashkenas";
    repo = "coffeescript";
    rev = version;
    hash = "sha256-vr46LKICX61rFPCkZ3G+8gJykg+MO43YRJnZGM3RoY0=";
  };

  npmDepsHash = "sha256-mCm31OwI3wjq8taKRQuEj4+IWVZO9Z5KuIDBf39lYoQ=";

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  dontNpmBuild = true;

  meta = {
    description = "A little language that compiles into JavaScript";
    homepage = "https://github.com/jashkenas/coffeescript";
    license = lib.licenses.mit;
    mainProgram = "coffee";
    maintainers = with lib.maintainers; [ cdmistman ];
  };
}
