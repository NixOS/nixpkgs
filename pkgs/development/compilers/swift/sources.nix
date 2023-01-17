{ lib, fetchFromGitHub }:

let

  # These packages are all part of the Swift toolchain, and have a single
  # upstream version that should match. We also list the hashes here so a basic
  # version upgrade touches only this file.
  version = "5.7";
  hashes = {
    llvm-project = "sha256-uW6dEAFaDOlHXnq8lFYxrKNLRPEukauZJxX4UCpWpIY=";
    sourcekit-lsp = "sha256-uA3a+kAqI+XFzkDFEJ8XuRTgfYqacEuTsOU289Im+0Y=";
    swift = "sha256-n8WVQYinAyIj4wmQnDhvPsH+t8ydANkGbjFJ6blfHOY=";
    swift-cmark = "sha256-f0BoTs4HYdx/aJ9HIGCWMalhl8PvClWD6R4QK3qSgAw=";
    swift-corelibs-foundation = "sha256-6XUSC6759dcG24YapWicjRzUnmVVe0QPSsLEw4sQNjI=";
    swift-corelibs-libdispatch = "sha256-1qbXiC1k9+T+L6liqXKg6EZXqem6KEEx8OctuL4Kb2o=";
    swift-corelibs-xctest = "sha256-qLUO9/3tkJWorDMEHgHd8VC3ovLLq/UWXJWMtb6CMN0=";
    swift-docc = "sha256-WlXJMAnrlVPCM+iCIhG0Gyho76BsC2yVBEpX3m/WiIQ=";
    swift-docc-render-artifact = "sha256-ttdurN/K7OX+I4577jG3YGeRs+GLUTc7BiiEZGmFD+s=";
    swift-driver = "sha256-sk7XWXYR1MGPEeVxA6eA/vxhN6Gq16iD1RHpVstL3zE=";
    swift-experimental-string-processing = "sha256-Ar9fQWi8bYSvGErrS0SWrxIxwEwCjsYIZcWweZ8bV28=";
    swift-package-manager = "sha256-MZah+/XfeK46YamxwuE3Kiv+u5bj7VmjEh6ztDF+0j4=";
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
