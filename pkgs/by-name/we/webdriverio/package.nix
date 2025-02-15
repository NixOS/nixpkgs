{ fetchFromGitHub
, buildNpmPackage
, lib
, nodePackages
, yq-go
, makeWrapper
, nodejs
, fetchpatch
, withChromedriver ? true, chromedriver
, withGeckodriver ? true, geckodriver
}:

buildNpmPackage rec {
  pname = "webdriverio";
  version = "8.32.2";

  src = fetchFromGitHub {
    owner = "webdriverio";
    repo = "webdriverio";
    rev = "v${version}";
    hash = "sha256-hDHIyDrnqG28f2npZy4AIhkZ89h+XVYNiYtmDqeTpdI=";
  };

  patches = [
    (fetchpatch {
      name = "Regenerate-lockfile.patch";
      url = "https://github.com/webdriverio/webdriverio/commit/33a588f9addacd55a48452c04ecf6a1b775fbc76.patch";
      hash = "sha256-cM9fcSizzLIH73WChS0toNb3nGhLKEwrS76kRa5ZqBc=";
    })
    (fetchpatch {
      name = "Add-chromedriver-env.patch";
      url = "https://github.com/webdriverio/webdriverio/pull/12339/commits/3b4238d446dd7957147658e446e5fae4baad723b.patch";
      hash = "sha256-okWEWliCOdNByRsv+AEaXmvsPr0cOSH2/AefRFrWaTM=";
    })
  ];

  npmDepsHash = "sha256-KOC9woFDCh+nTLBzuNQQ6fBwqDV5q3S/vcpP+8BGXlw=";
  npmFlags = [ "--legacy-peer-deps" "--ignore-scripts" ];

  nativeBuildInputs = [ yq-go nodePackages.rimraf makeWrapper ];

  postPatch = ''
    yq -i -o json '. + {"version":"${version}"}' package.json
  '';

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} $out/bin/wdio \
      ${lib.optionalString withGeckodriver "--set GECKODRIVER_FILEPATH ${lib.getExe geckodriver}"} \
      ${lib.optionalString withChromedriver "--set CHROMEDRIVER_FILEPATH ${lib.getExe chromedriver}"} \
      --add-flags $out/lib/node_modules/webdriverio-monorepo/node_modules/@wdio/cli/bin/wdio.js
  '';

  meta = {
    description = "Next-gen browser and mobile automation test framework for Node.js";
    homepage = "https://webdriver.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "wdio";
    inherit (nodejs.meta) platforms;
  };
}
