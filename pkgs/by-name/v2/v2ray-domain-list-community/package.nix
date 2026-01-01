{
  stdenv,
  pkgsBuildBuild,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

let
  generator = pkgsBuildBuild.buildGoModule rec {
    pname = "v2ray-domain-list-community";
<<<<<<< HEAD
    version = "20251213093556";
=======
    version = "20251126014742";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "domain-list-community";
      rev = version;
<<<<<<< HEAD
      hash = "sha256-ITZsD7bpYXsXmLlSL/zY3eh2yAy7Afwddw64SADmnSo=";
    };
    vendorHash = "sha256-HmIXpF7P3J+lPXpmWWoFpSYAu5zbBQSDrj6S88LgWSU=";
    meta = {
      description = "Community managed domain list";
      homepage = "https://github.com/v2fly/domain-list-community";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ nickcao ];
=======
      hash = "sha256-Z2hsfQV9io66RLKAcUgr+JnXgmc5qhXKeeaGoh5/3+E=";
    };
    vendorHash = "sha256-HmIXpF7P3J+lPXpmWWoFpSYAu5zbBQSDrj6S88LgWSU=";
    meta = with lib; {
      description = "Community managed domain list";
      homepage = "https://github.com/v2fly/domain-list-community";
      license = licenses.mit;
      maintainers = with maintainers; [ nickcao ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };
in
stdenv.mkDerivation {
  inherit (generator)
    pname
    version
    src
    meta
    ;
  buildPhase = ''
    runHook preBuild
    ${generator}/bin/domain-list-community -datapath $src/data
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -Dm644 dlc.dat $out/share/v2ray/geosite.dat
    runHook postInstall
  '';
  passthru = {
    inherit generator;
    updateScript = nix-update-script { };
  };
}
