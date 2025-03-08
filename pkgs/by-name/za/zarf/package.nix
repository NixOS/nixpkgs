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
    "x86_64-linux" = "sha256-8e77c8194a73fc82496f745f6517ef80f472560a574769eea8460d7d809c42eb";
    "aarch64-linux" = "sha256-3b6d45becb7c507a699c402744a84c578297b303716aff8e3078a3c479282722";
    "x86_64-darwin" = "sha256-94cbb26d0b2030ce416354f225e7dd04c6aa227a350b955af57b515de02c5709";
    "aarch64-darwin" = "sha256-203f6a0061331a30625308cad60f2f58eaaea4e1f8fd968463d1a1f876f94120";
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

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/zarf
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export K9S_LOGS_DIR=$(mktemp -d)
    installShellCompletion --cmd zarf \
      --bash <($out/bin/zarf completion --no-log-file bash) \
      --fish <($out/bin/zarf completion --no-log-file fish) \
      --zsh  <($out/bin/zarf completion --no-log-file zsh)
  '';

  meta = with lib; {
    description = "DevSecOps for Air Gap & Limited-Connection Systems. https://zarf.dev";
    homepage = "https://github.com/zarf-dev/zarf";
    license = licenses.asl20;
    maintainers = with maintainers; [ ragingpastry ];
    platforms = builtins.attrNames urls;
  };
}
