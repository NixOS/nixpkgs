{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:
buildNpmPackage rec {
  pname = "zeroshot";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "covibes";
    repo = "zeroshot";
    tag = "v${version}";
    hash = "sha256-Q4k2s3lqdaKbSI7FdhztQl9ARFIk2aAK95QPp6RcjD0=";
  };

  npmDepsHash = "sha256-woleUHcwGRSn5+rNDWgbKMbbue8QryItWECn5IA5ErI=";

  # Skip puppeteer's Chrome download during build
  PUPPETEER_SKIP_DOWNLOAD = true;

  # Package doesn't have a build script
  dontNpmBuild = true;

  nativeBuildInputs = [nodejs_22];
  propagatedBuildInputs = [nodejs_22];

  meta = {
    description = "Multi-agent AI coding orchestration CLI that autonomously implements, reviews, tests, and verifies code changes";
    homepage = "https://github.com/covibes/zeroshot";
    changelog = "https://github.com/covibes/zeroshot/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [caniko];
    mainProgram = "zeroshot";
    platforms = lib.platforms.unix;
  };
}
