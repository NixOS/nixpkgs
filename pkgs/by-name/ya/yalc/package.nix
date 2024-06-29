{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
}:

mkYarnPackage rec {
  pname = "yalc";
  version = "1.0.0-pre.53";

  src = fetchFromGitHub {
    owner = "wclr";
    repo = "yalc";
    # Upstream has no tagged versions
    rev = "214ab0371aedd2212e2b21a9b9481cbdaf742404";
    hash = "sha256-lnS6qWdUS7Zg3tkDPTlQfhv4VgNiCAs36CG2YmgkRK8=";
  };

  packageJSON = "${src}/package.json";
  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-g9D+FWO4fiTvxZtOgWKKF45CylmCFTW3pouGLJGdEX0=";
  };

  buildPhase = ''
    runHook preBuild
    yarn --offline build
    runHook postBuild
  '';

  postInstall = ''
    substituteInPlace $out/bin/yalc \
      --replace-fail "/usr/bin/env node" "${lib.getExe nodejs}"
    chmod +x $out/libexec/yalc/deps/yalc/src/yalc.js
  '';

  meta = with lib; {
    description = "Framework for converting Left-To-Right (LTR) Cascading Style Sheets(CSS) to Right-To-Left (RTL)";
    mainProgram = "rtlcss";
    homepage = "https://rtlcss.com";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
