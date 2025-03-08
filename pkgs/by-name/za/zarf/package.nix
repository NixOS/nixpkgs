{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
}:

let
  version = "0.49.1";

  # Define the architecture-specific URLs
  urls = {
    "x86_64-linux" = "https://github.com/zarf-dev/zarf/releases/download/v${version}/zarf_v${version}_Linux_amd64";
    "aarch64-linux" = "https://github.com/zarf-dev/zarf/releases/download/v${version}/zarf_v${version}_Linux_arm64";
    "x86_64-darwin" = "https://github.com/zarf-dev/zarf/releases/download/v${version}/zarf_v${version}_Darwin_amd64";
    "aarch64-darwin" = "https://github.com/zarf-dev/zarf/releases/download/v${version}/zarf_v${version}_Darwin_arm64";
  };

  hashes = {
    "x86_64-linux" = "1ss2kj07s3a6m3p6jisp19b75x40xwbnapvldx4q5z3k98cwhxwf";
    "aarch64-linux" = "08i751ww98vq627gyski0frrg0jp9jl489s0kilpll3wrfz4av9v";
    "x86_64-darwin" = "02ap5kh5slbvymd9a2rmg8iamih4vpkjbwjlcd0wwc101dnv5jwl";
    "aarch64-darwin" = "0821z5vgi8ficf29dzgqw6jaxsjq5w7xdjh8adi306ikc406lgr0";
  };

  platform = stdenv.hostPlatform.system;
  src = fetchurl {
    url = urls.${platform} or (throw "Unsupported platform: ${platform}");
    sha256 = hashes.${platform} or (throw "Missing hash for platform: ${platform}");
  };

in stdenv.mkDerivation {
  pname = "zarf";
  inherit version src;

  nativeBuildInputs = [ installShellFiles ];

  unpackPhase = "true";

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
