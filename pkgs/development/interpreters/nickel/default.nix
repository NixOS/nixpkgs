{ lib
, rustPlatform
, fetchFromGitHub
, python3
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "nickel";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-g7pRTwa2sniIOmgdYCxfYxGRtxnQP8zaVWuPjzEZTSg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "topiary-0.2.3" = "sha256-DcmrQ8IuvUBDCBKKSt13k8rU8DJZWFC8MvxWB7dwiQM=";
      "tree-sitter-bash-0.20.3" = "sha256-zkhCk19kd/KiqYTamFxui7KDE9d+P9pLjc1KVTvYPhI=";
      "tree-sitter-facade-0.9.3" = "sha256-M/npshnHJkU70pP3I4WMXp3onlCSWM5mMIqXP45zcUs=";
      "tree-sitter-nickel-0.0.1" = "sha256-aYsEx1Y5oDEqSPCUbf1G3J5Y45ULT9OkD+fn6stzrOU=";
      "tree-sitter-query-0.1.0" = "sha256-5N7FT0HTK3xzzhAlk3wBOB9xlEpKSNIfakgFnsxEi18=";
      "web-tree-sitter-sys-1.3.0" = "sha256-9rKB0rt0y9TD/HLRoB9LjEP9nO4kSWR9ylbbOXo2+2M=";
    };
  };

  cargoBuildFlags = [ "-p nickel-lang-cli" "-p nickel-lang-lsp" ];

  nativeBuildInputs = [
    python3
  ];

  outputs = [ "out" "nls" ];

  postInstall = ''
    mkdir -p $nls/bin
    mv $out/bin/nls $nls/bin/nls
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://nickel-lang.org/";
    description = "Better configuration for less";
    longDescription = ''
      Nickel is the cheap configuration language.

      Its purpose is to automate the generation of static configuration files -
      think JSON, YAML, XML, or your favorite data representation language -
      that are then fed to another system. It is designed to have a simple,
      well-understood core: it is in essence JSON with functions.
    '';
    changelog = "https://github.com/tweag/nickel/blob/${version}/RELEASES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres felschr matthiasbeyer ];
  };
}
