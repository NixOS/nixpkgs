{ lib
, fetchurl
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "terramate-bin";
  version = "0.5.5";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        aarch64-darwin = "darwin_arm64";
        aarch64-linux = "linux_arm64";
        i686-linux = "linux_i386";
        x86_64-darwin = "darwin_x86_64";
        x86_64-linux = "linux_x86_64";
      };
      sha256 = selectSystem {
        aarch64-darwin = "sha256-hSgXrZOiSxWZLOk+LfnLwBSg2uJYXGhsf+/iX51UNBo=";
        aarch64-linux = "sha256-gp1+8nX/PtZIRNKwzSY2sZBfGEeMD6RiMIfZkY3mHIg=";
        i686-linux = "sha256-315bOT3acQzc4Hb2QPuW7VrkIox9bh1O83lT7XKpdzw=";
        x86_64-darwin = "sha256-aU3FnSO25JWn6L4WHYOKFGX+uoYCR89cKiqLD4iiQG8=";
        x86_64-linux = "sha256-pgcbMC++Z+Rz1cKLHMXlVBi3bjD9Dtg+O68Dz4XoU8s=";
      };
    in
    fetchurl {
      url = "https://github.com/terramate-io/terramate/releases/download/v${version}/terramate_${version}_${suffix}.tar.gz";
      inherit sha256;
    };

  doInstallCheck = true;

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontPatchShebangs = true;
  dontStrip = stdenv.isDarwin;

  noAuditTmpdir = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -D terramate $out/bin/terramate
    install -D terramate-ls $out/bin/terramate-ls
    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/terramate version
    $out/bin/terramate-ls -version
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Adds code generation, stacks, orchestration, change detection, data sharing and more to Terraform";
    homepage = "https://github.com/terramate-io/terramate";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mpl20;
    maintainers = with maintainers; [ asininemonkey ];
    mainProgram = "terramate";
    platforms = [ "aarch64-darwin" "aarch64-linux" "i686-linux" "x86_64-darwin" "x86_64-linux" ];
  };
}
