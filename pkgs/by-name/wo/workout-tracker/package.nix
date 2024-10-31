{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  ...
}:
let
  pname = "workout-tracker";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "workout-tracker";
    rev = "refs/tags/v${version}";
    hash = "sha256-Sn6SOHrsp1ZgsPntc2+cmlAEPVBUrYv1vKLKAQvT9m4=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-jHpvCMgjGvaAOfbslaIKfIRiPafScpn3WLnYamm+lbs=";
    dontNpmBuild = true;
    postPatch = ''
      rm Makefile
    '';
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
    '';
  };
in
buildGoModule rec {
  inherit pname version src;

  vendorHash = null;

  postPatch = ''
    ln -s ${assets}/node_modules ./node_modules
    make build-dist
  '';

  passthru.updateScript = nix-update-script { };

  passthru.tests = {
    inherit (nixosTests) workout-tracker;
  };

  meta = {
    changelog = "https://github.com/jovandeginste/workout-tracker/releases/tag/v${version}";
    description = "Workout tracking web application for personal use";
    homepage = "https://github.com/jovandeginste/workout-tracker";
    license = lib.licenses.mit;
    mainProgram = "workout-tracker";
    maintainers = with lib.maintainers; [ bhankas ];
  };
}
