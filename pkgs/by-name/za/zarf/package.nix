{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "zarf";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "defenseunicorns";
    repo = "zarf";
    rev = "v${version}";
    hash = "sha256-rY9xWqJ+2Yfs6VRHTF89LmuEruAavDI7MgBm4UFEuBs=";
  };

  vendorHash = "sha256-Cz+w0tOEamCxf61hvQ03X/kXPY+qrmdBN8s26lr/wZ8=";
  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    mkdir -p build/ui
    touch build/ui/index.html
  '';

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/defenseunicorns/zarf/src/config.CLIVersion=${src.rev}"
    "-X"
    "k8s.io/component-base/version.gitVersion=v0.0.0+zarf${src.rev}"
    "-X"
    "k8s.io/component-base/version.gitCommit=${src.rev}"
    "-X"
    "k8s.io/component-base/version.buildDate=1970-01-01T00:00:00Z"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export K9S_LOGS_DIR=$(mktemp -d)
    installShellCompletion --cmd zarf \
      --bash <($out/bin/zarf completion --no-log-file bash) \
      --fish <($out/bin/zarf completion --no-log-file fish) \
      --zsh  <($out/bin/zarf completion --no-log-file zsh)
  '';

  meta = with lib; {
    description = "DevSecOps for Air Gap & Limited-Connection Systems. https://zarf.dev";
    mainProgram = "zarf";
    homepage = "https://github.com/defenseunicorns/zarf.git";
    license = licenses.asl20;
    maintainers = with maintainers; [ ragingpastry ];
  };
}


{ lib, stdenv, fetchurl }:

let
  version = "0.49.1";

  # Define the architecture-specific URLs
  urls = {
    "x86_64-linux" = "https://github.com/zarf-dev/zarf/releases/download/v${version}/zarf_v${version}_Linux_amd64";
    "aarch64-linux" = "https://github.com/zarf-dev/zarf/releases/download/v${version}/zarf_v${version}_Linux_arm64";
    "x86_64-darwin" = "https://github.com/zarf-dev/zarf/releases/download/v${version}/zarf_v${version}_Darwin_amd64";
    "aarch64-darwin" = "https://github.com/zarf-dev/zarf/releases/download/v${version}/zarf_v${version}_Darwin_arm64";
  };

  # Define architecture-specific hashes (update these with correct hashes)
  hashes = {
    "x86_64-linux" = "sha256-UPDATE_THIS_HASH_AMD64";
    "aarch64-linux" = "sha256-UPDATE_THIS_HASH_ARM64";
    "x86_64-darwin" = "sha256-UPDATE_THIS_HASH_MAC_AMD64";
    "aarch64-darwin" = "sha256-UPDATE_THIS_HASH_MAC_ARM64";
  };

  # Select the correct binary URL and hash for the current system
  platform = stdenv.hostPlatform.system;
  src = fetchurl {
    url = urls.${platform} or (throw "Unsupported platform: ${platform}");
    sha256 = hashes.${platform} or (throw "Missing hash for platform: ${platform}");
  };

in stdenv.mkDerivation {
  pname = "zarf";
  inherit version src;

  nativeBuildInputs = [];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/zarf
  '';

  meta = with lib; {
    description = "DevSecOps for Air Gap & Limited-Connection Systems. https://zarf.dev";
    homepage = "https://github.com/zarf-dev/zarf";
    license = licenses.asl20;
    maintainers = with maintainers; [ ragingpastry ];
    platforms = builtins.attrNames urls; # Automatically set supported platforms
  };
}
