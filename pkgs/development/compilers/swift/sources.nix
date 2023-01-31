{ lib, fetchFromGitHub }:

let

  # These packages are all part of the Swift toolchain, and have a single
  # upstream version that should match. We also list the hashes here so a basic
  # version upgrade touches only this file.
  version = "5.7.3";
  hashes = {
    llvm-project = "sha256-IDtLPe0sXamnmovbFVKvmDMnci4u/A0urAPjWTYwJCo=";
    sourcekit-lsp = "sha256-BT6+VCBSupKOg2mXo6HlkvNRc8pVZU772Mj3LKFamsU=";
    swift = "sha256-essP2eIp1sLuROqk0OKGBPfJnvnyAW0moMk0cX1IVQQ=";
    swift-cmark = "sha256-f0BoTs4HYdx/aJ9HIGCWMalhl8PvClWD6R4QK3qSgAw=";
    swift-corelibs-foundation = "sha256-g78zKSq/b/pVFAD2k2SoMpzJQIpkxMvZOaSz5JPaQmA=";
    swift-corelibs-libdispatch = "sha256-1qbXiC1k9+T+L6liqXKg6EZXqem6KEEx8OctuL4Kb2o=";
    swift-corelibs-xctest = "sha256-qLUO9/3tkJWorDMEHgHd8VC3ovLLq/UWXJWMtb6CMN0=";
    swift-docc = "sha256-WlXJMAnrlVPCM+iCIhG0Gyho76BsC2yVBEpX3m/WiIQ=";
    swift-docc-render-artifact = "sha256-ttdurN/K7OX+I4577jG3YGeRs+GLUTc7BiiEZGmFD+s=";
    swift-driver = "sha256-BUwsvw8pirvprUFfliLQMMHr6SHTSgeaJYc9lTEvi9E=";
    swift-experimental-string-processing = "sha256-W0cQBkdR3A0hrV75Wwm0YULUDVg1bjT0O5w5VGBYDJs=";
    swift-package-manager = "sha256-zlFYh1wdjUwOsnbagKnAtqXl3vKPcRtnA7YMORtUeyg=";
  };

  # Create fetch derivations.
  sources = lib.mapAttrs (repo: hash: fetchFromGitHub {
    owner = "apple";
    inherit repo;
    rev = "swift-${version}-RELEASE";
    name = "${repo}-${version}-src";
    hash = hashes.${repo};
  }) hashes;

in sources // { inherit version; }
