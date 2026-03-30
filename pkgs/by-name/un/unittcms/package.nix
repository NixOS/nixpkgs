{
  lib,
  stdenvNoCC,
  callPackage,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
  # default backend settings
  defaultNodeEnv ? "production",
  defaultBackendPort ? 8001,
  defaultFrontendOrigin ? "http://${defaultHostname}:${toString defaultFrontendPort}",
  defaultSecretKey ? "",
  # default frontend settings
  defaultHostname ? "localhost",
  defaultFrontendPort ? 8000,
  defaultBackendOrigin ? "/api",
  defaultIsDemo ? "false",
}:

let
  pname = "unittcms";
  version = "1.0.0-beta.27";

  src = fetchFromGitHub {
    owner = "kimatata";
    repo = "unittcms";
    tag = "v${version}";
    hash = "sha256-h+bAxFB25Hk20WvHus7NPUFwKw+s+JynUSJyf0UtlP8=";
  };

  backend = callPackage ./backend {
    inherit
      pname
      version
      src
      defaultNodeEnv
      defaultBackendPort
      defaultFrontendOrigin
      defaultSecretKey
      ;
  };
  frontend = callPackage ./frontend {
    inherit
      pname
      version
      src
      defaultHostname
      defaultFrontendPort
      defaultBackendOrigin
      defaultIsDemo
      ;
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${backend}/bin/* ${frontend}/bin/* $out/bin/
    ln -s ${backend}/lib ${frontend}/share $out

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) unittcms;
    };
  };

  meta = {
    description = "Open source test case management system designed for self-hosted use";
    homepage = "https://www.unittcms.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ RadxaYuntian ];
  };
}
