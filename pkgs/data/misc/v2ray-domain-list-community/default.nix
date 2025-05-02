{ stdenv, pkgsBuildBuild, fetchFromGitHub, lib, nix-update-script }:

let
  generator = pkgsBuildBuild.buildGoModule rec {
    pname = "v2ray-domain-list-community";
    version = "20240426060244";
    src = fetchFromGitHub {
      owner = "v2fly";
      repo = "domain-list-community";
      rev = version;
      hash = "sha256-DkZcqjYwXRNlRnfwbRZL6zlkYL9kig3cZ5H6LEzakeY=";
    };
    vendorHash = "sha256-azvMUi8eLNoNofRa2X4SKTTiMd6aOyO6H/rOiKjkpIY=";
    meta = with lib; {
      description = "community managed domain list";
      homepage = "https://github.com/v2fly/domain-list-community";
      license = licenses.mit;
      maintainers = with maintainers; [ nickcao ];
    };
  };
in
stdenv.mkDerivation {
  inherit (generator) pname version src meta;
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
